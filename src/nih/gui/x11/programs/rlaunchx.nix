{
  config,
  lib,
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
    environment.systemPackages =
      let
        nushell = "${pkgs.nushell}/bin/nu";
        rlaunch = "${pkgs.rlaunch}/bin/rlaunch";
        alacritty = "${pkgs.alacritty}/bin/alacritty";
        font = cfgGui.style.fonts.sansSerif;
        colors = cfgPalette.colors;
        args = (
          lib.escapeShellArgs [
            "-f"
            "${font.family}:size=${builtins.toString (font.defaultSize - 2)}"
            "--color0"
            colors.surface0
            "--color1"
            colors.surface1
            "--color2"
            colors.text
            "--color3"
            colors.text
            "--color4"
            colors.surface0
            "--terminal"
            alacritty
          ]
        );
        package = pkgs.writeTextFile {
          name = "rlaunchx";
          text = ''
            #!${nushell}
            ${rlaunch} ${args}
          '';
          executable = true;
          destination = "/bin/rlaunchx";
        };
      in
      [ package ];
  };
}
