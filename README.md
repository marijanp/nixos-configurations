## Configuration structure

All deployable NixOS configurations can be found in the `flake.nix`.

Use `nix flake show` to display them.

Each NixOS configuration exposed in the `flake.nix` assembles different configuration files from different directories together.

The directories contain configuration files for affecting different aspects of the system:
- The `machines` directory contains hardware specific configuration files for the different target hosts
- The `dotfiles` directory contains home-manager configuration files affecting a specific user
- The `environments` directory contains NixOS system configuration files that assemble configurations from the `services`, and `options` depending on the use of the final system.

In the following sections I describe what each subdirectory contains.

## The `machines` directory

The `machines` directory contains a subdirectory for every physical machine running NixOS.

Each of those machine directories contains
- the generated `hardware-configuration.nix`
- hardware specific configuration files like `bluetooth.nix` and `networking.nix`

## The `dotfiles` directory

The `dotfiles` directory contains configurations for *user* applications and services like `nvim`, `git`, etc.. It also contains the following files which assmble these configurations depending on the use of the final system.

- `common.nix` unifies all *user* application configurations that can be used on any machine.
- `desktop.nix` unifies all *user* application configurations that can be used on machines with a desktop.
- `work.nix` contains *user* applications that are only used for work.

## The `environments` directory

The `environments` directory contains NixOS *system* configuration files that assemble configurations from the `services`, and `options` depending on the use of the final system:

- `common.nix` unifies all *system* configuration files that can be used on any machine.
- `desktop.nix` unifies all *system* configurations that can be used on machines with a desktop.
- `work.nix` contains *system* configurations that are only used for work.

## The `options` directory

This directory contains all *system* configurations which are not services.

## The `services` directory

This directory contains all *system* service configurations.
