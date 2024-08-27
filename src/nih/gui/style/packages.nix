{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
in
{
  config = lib.mkIf cfg.enable {
    nih.gui.style.packages = {
      cursors = (
        lib.getAttr ("${cfgPalette.variant}${lib.nih.capStr cfgPalette.accent}") pkgs.catppuccin-cursors
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
          Inherits=${cfgGui.style.cursors.name}
        '';
      };
      qt = pkgs.stdenvNoCC.mkDerivation {
        pname = "catppuccin-kvantum";
        version = npins.catppuccin-kvantum.revision;
        src = npins.catppuccin-kvantum;
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/Kvantum
          cp -a themes/* $out/share/Kvantum
          runHook postInstall
        '';
      };
    };
  };
}
