# NixOS configuration

## USAGE

```sh
nixos-rebuild switch --flake '.#%device%'
```

Available devices:

- legion
- yoga

### DCONF

dconf configuration is locked in
src/workspace/system/environment.nix
Don't forget to run `dconf update` as root
after every change in `/etc/dconf`.

Currently it locks `/org/gtk/settings/file-chooser/window-size` only
to prevent getting a file dialog out of screen bounds.

### THEME

Default theme is `Catppuccin Mocha Green`.

You need to install additional themes for Telegram and Firefox.
Also don't forget about userstyles.

- [Telegram](https://t.me/addtheme/ctpmochaimproved)
- [Firefox](https://github.com/catppuccin/firefox)
- [Userstyles](https://github.com/catppuccin/userstyles)
