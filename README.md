## Overview

All deployable NixOS configurations are defined in `flake.nix`. Run `nix flake show` to list them.

### Directory structure

| Directory | Purpose |
|-----------|---------|
| `machines/` | Per-host configurations, overrides, hardware and networking config |
| `system/` | Shared NixOS system configuration |
| `system/services/` | System service modules |
| `system/options/` | Non-service system options (fonts, locale, networking, nix, sound) |
| `dotfiles/` | Home-manager user configuration |
| `users/` | System per-user config |
| `modules/` | Custom NixOS modules |
| `pkgs/` | Custom package definitions |
| `secrets/` | sops-nix encrypted secrets |
