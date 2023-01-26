## Configuration structure

All deployable NixOS configurations can be found in the `flake.nix`.

Each configuration in the `flake.nix` plugs together
- `hardware` specific configurations from the `machines` subdirectory
- `user` specific configurations from the `dotfiles` directory
- `system` specific configurations from the `environments` directory,
  which in turn plugs together configurations from the `services`, and `options` directory

In the following sections I describe what each subdirectory should contain.

## The `machines` directory

The `machines` directory contains a subdirectory for every physical machine running NixOS.

Each of those machine directories contains the
- generated `hardware-configuration.nix`
- hardware specific configurations like `bluetooth` and `networking`

## The `dotfiles` directory

The `dotfiles` directory contains configurations for `user` application configurations like `nvim`, `git`, etc. and the following files that combine these `user` application configurations depending on the usage `environment`.

- `common` unifies all `user` application configurations that can be used on any machine.
- `desktop` unifies all `user` application configurations that can be used on machines with a desktop.
- `work` contains `user` applications that are only used for work.

## The `environments` directory

The `environments` directory unifies `system` related configurations from the `services`, `options`, etc. directory depending on the environment

- `common` unifies all `system` configurations that can be used on any machine.
- `desktop` unifies all `system` configurations that can be used on machines with a desktop.
- `work` contains `system` configurations that are only used for work.

## The `options` directory

This directory contains all `system` configurations from the `options` category.

## The `services` directory

This directory contains all `system` configurations from the `services` category.

