{ python3 }:

python3.pkgs.buildPythonApplication {
  pname = "zeroclaw-xmpp-bridge";
  version = "0.1.0";
  src = ./src;
  format = "pyproject";

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    slixmpp
    slixmpp-omemo
    aiohttp
  ];

  doCheck = false;
}
