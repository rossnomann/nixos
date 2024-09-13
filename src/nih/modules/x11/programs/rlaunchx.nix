{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  cfgX11 = cfg.x11;
in
{
  options.nih.x11.programs.rlaunchx = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgX11.programs.rlaunchx.package ];
    nih.x11.programs.rlaunchx.executable = "${cfgX11.programs.rlaunchx.package}/bin/rlaunchx";
    nih.x11.programs.rlaunchx.package =
      let
        colors = cfgStyle.palette.colors;
        font = cfgStyle.fonts.sansSerif;
      in
      pkgs.nih.rlaunchx {
        arguments = lib.escapeShellArgs [
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
          cfgPrograms.terminal.executable
        ];
        shellPath = cfgPrograms.cli.nushell.executable;
      };
  };
}
