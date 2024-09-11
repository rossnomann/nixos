{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    nih.style.packages = {
      cursors = (
        lib.getAttr "${cfgPalette.variant}${lib.nih.strings.capitalize cfgPalette.accent}" pkgs.catppuccin-cursors
      );
      gtk = pkgs.catppuccin-gtk.override {
        accents = [ cfgPalette.accent ];
        size = "compact";
        tweaks = [ "rimless" ];
        variant = cfgPalette.variant;
      };
      index = pkgs.writeTextFile {
        # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
        name = "index.theme";
        destination = "/share/icons/default/index.theme";
        text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cfgStyle.cursors.name}
        '';
      };
      qt = pkgs.nih.catppuccin-kvantum;
    };
  };
}
