{ config, pkgs, ... }:
{
  imports = [
    ./console.nix
    ./cursor.nix
    ./fonts.nix
    ./gtk.nix
    ./notifications.nix
    ./palette.nix
    ./portal.nix
    ./qt.nix
    ./wm
  ];
  config = {
    workspace.ui = {
      cursorTheme = {
        name = "catppuccin-mocha-green-cursors";
        package = pkgs.catppuccin-cursors.mochaGreen;
      };
      font = {
        packages = [
          pkgs.roboto
          pkgs.roboto-serif
          pkgs.fira-code
          pkgs.fira-code-symbols
        ];
        monospace = {
          family = "Fira Code";
        };
        sansSerif = {
          family = "Roboto";
        };
        serif = {
          family = "Roboto Serif";
        };
      };
      gtkTheme = {
        name = "catppuccin-mocha-green-compact+rimless";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "green" ];
          size = "compact";
          tweaks = [ "rimless" ];
          variant = "mocha";
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      qtTheme = {
        kvantumTheme = {
          name = "Catppuccin-Mocha-Green";
          package = (
            pkgs.catppuccin-kvantum.override {
              accent = "Green";
              variant = "Mocha";
            }
          );
        };
        platformThemeName = "adwaita";
        styleName = "kvantum";
      };
    };
  };
}
