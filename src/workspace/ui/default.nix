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
        name = "Catppuccin-Mocha-Green-Cursors";
        package = pkgs.catppuccin-cursors.mochaGreen;
        size = 16;
      };
      dpi = 144;
      font =
        let
          defaultSize = 10;
        in
        {
          packages = [
            pkgs.roboto
            pkgs.roboto-serif
            pkgs.fira-code
            pkgs.fira-code-symbols
          ];
          monospace = {
            family = "Fira Code";
            inherit defaultSize;
          };
          sansSerif = {
            family = "Roboto";
            inherit defaultSize;
          };
          serif = {
            family = "Roboto Serif";
            inherit defaultSize;
          };
        };
      gtkTheme = {
        name = "Catppuccin-Mocha-Compact-Green-Dark";
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
      wm = {
        gutterSize = 12;
        marginSize = 6;
      };
    };
  };
}
