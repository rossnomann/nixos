# NixOS configuration

My distraction free NixOS config based on X11 and LeftWM.

![preview](./resources/preview.png)

## USAGE

```sh
nixos-rebuild switch --flake '.#%device%'
```

See `outpus.nixosConfigurations` in `flake.nix` for the list of available devices.

### QUIRKS

#### GTK FILE CHOOSER

The GTK file chooser goes out of screen bounds in LeftWM.
Despite the corresponding [issue](https://github.com/leftwm/leftwm/issues/680) being resolved,
it doesn't appear to be fixed.
The only solution is to lock the file chooser size (see ./src/workspace/modules/ui/default.nix).
After every change in `/etc/dconf`, `dconf` update needs to be executed manually to apply settings.

#### TUIGREET

https://github.com/apognu/tuigreet/issues/126

#### THEME

Almost every program uses a Catppuccin theme. However not all of them can be configured using nix or have such theme at all.

For Telegram install theme using the following link: https://t.me/addtheme/ctpmochaimproved
For [Firefox](https://github.com/catppuccin/firefox) and [Userstyles](https://github.com/catppuccin/userstyles) choose the "mocha" flavor with "green" accent.
There is no theme for Hydrogen, DeaDBeeF and TuxGuitar, but they can be configured manually.
Ardour, Ocenaudio and Sublime Merge do not have Catppuccin themes at all, at least for now.
