# NixOS configuration

My NixOS config based on X11 and LeftWM.

![preview](./resources/preview.png)

## USAGE

```sh
nixos-rebuild switch --flake '.#%device%'
```

See `outpus.nixosConfigurations` in `flake.nix` for the list of available devices.

### QUIRKS

#### THEME

Almost every program uses a Catppuccin theme. However not all of them can be configured using nix or have such theme at all.

- Telegram: https://t.me/addtheme/ctpmochaimproved
- Firefox: https://github.com/catppuccin/firefox - choose the "mocha" flavor with "green" accent.
- Userstyles: https://github.com/catppuccin/userstyles - choose the "mocha" flavor with "green" accent.

There is no theme for Hydrogen and DeaDBeeF, but they can be configured manually.

Ardour, Musescore, Ocenaudio and Sublime Merge do not have Catppuccin themes at all, at least for now.
