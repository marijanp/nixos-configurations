"""ZeroClaw XMPP bridge — receives XMPP messages (decrypting OMEMO if present),
forwards them to ZeroClaw's webhook channel, and sends replies back with OMEMO encryption.

Environment variables:
  XMPP_JID        bot Jabber ID (e.g. bot@example.com)
  XMPP_PASSWORD   XMPP account password
  ZEROCLAW_URL    URL the bridge forwards incoming XMPP messages to
  LISTEN_HOST     Host the bridge binds to (default: 127.0.0.1)
  LISTEN_PORT     Port the bridge binds to (default: 5000)
  ALLOWED_JIDS    comma-separated bare JIDs allowed to send, or * for all (default: *)
  DATA_DIR        persistent OMEMO key storage (default: /var/lib/zeroclaw-xmpp-bridge)
"""

from __future__ import annotations

import asyncio
import json
import logging
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any, FrozenSet, Optional

import slixmpp
from slixmpp.jid import JID
from slixmpp.plugins.base import register_plugin as slixmpp_register_plugin
from slixmpp_omemo import TrustLevel, XEP_0384
from omemo.session_manager import EncryptionError
from omemo.storage import Just, Maybe, Nothing, Storage
from omemo.types import DeviceInformation
from aiohttp import ClientSession, web

log = logging.getLogger(__name__)


@dataclass(frozen=True)
class Config:
    listen_host: str
    listen_port: int
    jid: str
    password: str
    zeroclaw_url: str
    allowed_jids: frozenset[str]
    data_dir: str

    @staticmethod
    def from_env() -> Config:
        return Config(
            listen_host=os.environ.get("LISTEN_HOST", "127.0.0.1"),
            listen_port=int(os.environ.get("LISTEN_PORT", "5000")),
            jid=os.environ["XMPP_JID"],
            password=os.environ["XMPP_PASSWORD"],
            zeroclaw_url=os.environ["ZEROCLAW_URL"],
            allowed_jids=frozenset(os.environ.get("ALLOWED_JIDS", "*").split(",")),
            data_dir=os.environ.get("DATA_DIR", "/var/lib/zeroclaw-xmpp-bridge"),
        )


class JSONFileStorage(Storage):
    """Key-value store backed by a single JSON file, used for OMEMO state persistence."""

    def __init__(self, data_dir: str) -> None:
        super().__init__()
        self._path = Path(data_dir) / "omemo.json"
        self._data: dict = json.loads(self._path.read_text()) if self._path.exists() else {}

    def _save(self) -> None:
        self._path.parent.mkdir(parents=True, exist_ok=True)
        self._path.write_text(json.dumps(self._data))

    async def _load(self, key: str) -> Maybe:
        return Just(self._data[key]) if key in self._data else Nothing()

    async def _store(self, key: str, value: Any) -> None:
        self._data[key] = value
        self._save()

    async def _delete(self, key: str) -> None:
        self._data.pop(key, None)
        self._save()


class OmemoPlugin(XEP_0384):
    """XEP-0384 plugin with BTBV (Blind Trust Before Verification) and JSON file storage."""

    @property
    def storage(self) -> Storage:
        if not hasattr(self, "_storage_instance"):
            self._storage_instance = JSONFileStorage(self.config["data_dir"])
        return self._storage_instance

    @property
    def _btbv_enabled(self) -> bool:
        return True

    async def _prompt_manual_trust(
        self, manually_trusted: FrozenSet[DeviceInformation], identifier: Optional[str]
    ) -> None:
        session_manager = await self.get_session_manager()
        for device in manually_trusted:
            await session_manager.set_trust(
                device.bare_jid, device.identity_key, TrustLevel.BLINDLY_TRUSTED.value
            )


slixmpp_register_plugin(OmemoPlugin)


class Bridge(slixmpp.ClientXMPP):
    def __init__(self, config: Config, http: ClientSession) -> None:
        super().__init__(config.jid, config.password)
        self._config = config
        self._http = http
        self.use_message_ids = True
        self.auto_authorize = True

        self.register_plugin("xep_0004")  # data forms, required by OMEMO
        self.register_plugin("xep_0030")  # service discovery, required by OMEMO
        self.register_plugin("xep_0060")  # pubsub, required for OMEMO key distribution
        self.register_plugin("xep_0163")  # personal eventing protocol, required by OMEMO
        self.register_plugin("xep_0199")  # XMPP ping keepalive
        self.register_plugin("xep_0280")  # message carbons, required by OMEMO
        self.register_plugin("xep_0334")  # message processing hints, required by OMEMO
        self.register_plugin("xep_0384", pconfig={"data_dir": config.data_dir})

        self.add_event_handler("session_start", self._on_start)
        self.add_event_handler("message", self._on_message)

    async def _on_start(self, _: Any) -> None:
        await self.get_roster()
        self.send_presence()
        log.info(f"XMPP online as {self.boundjid.full}")

    async def _on_message(self, msg: Any) -> None:
        if msg["type"] not in ("chat", "normal"):
            return

        if self["xep_0384"].is_encrypted(msg):
            try:
                msg, _ = await self["xep_0384"].decrypt_message(msg)
            except Exception as exc:
                log.warning(f"OMEMO decrypt failed from {msg['from']}: {exc}")
                return

        body = msg["body"]
        if not body or not body.strip():
            return

        sender = str(msg["from"].bare if hasattr(msg["from"], "bare") else msg["from"]).split("/")[0]
        if "*" not in self._config.allowed_jids and sender.lower() not in {j.lower() for j in self._config.allowed_jids}:
            log.info(f"Denied message from {sender}")
            return

        log.info(f"Forwarding from {sender}")
        try:
            async with self._http.post(self._config.zeroclaw_url, json={"sender": sender, "content": body}) as r:
                r.raise_for_status()
        except Exception as exc:
            log.warning(f"POST to {self._config.zeroclaw_url} failed: {exc}")

    async def send_encrypted(self, recipient: str, content: str) -> None:
        stanza = self.make_message(mto=recipient, mbody=content, mtype="chat")
        try:
            encrypted, errors = await self["xep_0384"].encrypt_message(stanza, JID(recipient))
            if errors:
                log.warning(f"Non-fatal OMEMO encryption errors for {recipient}: {errors}")
            for enc_msg in encrypted.values():
                enc_msg.send()
        except Exception as exc:
            log.warning(f"OMEMO encrypt for {recipient} failed ({exc}), sending plaintext")
            self.send_message(mto=recipient, mbody=content, mtype="chat")


async def run() -> None:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s %(message)s")
    config = Config.from_env()

    async with ClientSession() as http:
        bot = Bridge(config, http)

        async def reply(request: web.Request) -> web.Response:
            data: dict[str, str] = await request.json()
            await bot.send_encrypted(data["recipient"], data["content"])
            return web.Response(status=204)

        app = web.Application()
        app.router.add_post("/send", reply)
        runner = web.AppRunner(app)
        await runner.setup()
        await web.TCPSite(runner, config.listen_host, config.listen_port).start()
        log.info(f"Reply server on {config.listen_host}:{config.listen_port}")

        bot.connect()
        await bot.disconnected
        await runner.cleanup()

def main() -> None:
    asyncio.run(run())

if __name__ == "__main__":
    main()
