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
  options.nih.programs.graphics.gimp = {
    enable = lib.mkEnableOption "GIMP";
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.graphics.gimp.enable) {
    environment.systemPackages = [ cfgPrograms.graphics.gimp.package ];
    nih.programs.graphics.gimp.executable = "${cfgPrograms.graphics.gimp.package}/bin/gimp";
    nih.programs.graphics.gimp.package = pkgs.gimp3-with-plugins.override {
      plugins = [ pkgs.gimp3Plugins.gmic ];
    };
    nih.graphicalSession.windowRules = [
      {
        appId = ''^gimp'';
        workspace = "main";
      }
      {
        appId = ''^fr\\.greyc\\.$'';
        workspace = "main";
      }
    ];
  };
}
