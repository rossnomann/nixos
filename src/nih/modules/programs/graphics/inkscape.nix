{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.graphics.inkscape = {
    enable = lib.mkEnableOption "Inkscape";
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.graphics.inkscape.enable) {
    environment.systemPackages = [
      cfgPrograms.graphics.gimp.package
      cfgPrograms.graphics.inkscape.package
    ];
    nih.programs.graphics.inkscape.executable = "${cfgPrograms.graphics.inkscape.package}/bin/inkscape";
    nih.programs.graphics.inkscape.package = pkgs.inkscape;
    nih.graphicalSession.windowRules = [
      {
        appId = ''^org\\.inkscape\\.Inkscape'';
        workspace = "main";
      }
    ];
  };
}
