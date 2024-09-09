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
        palette = cfgPalette.current;
        args = (
          lib.escapeShellArgs [
            "-f"
            "${font.family}:size=${builtins.toString (font.defaultSize - 2)}"
            "--color0"
            palette.surface0
            "--color1"
            palette.surface1
            "--color2"
            palette.text
            "--color3"
            palette.text
            "--color4"
            palette.surface0
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
