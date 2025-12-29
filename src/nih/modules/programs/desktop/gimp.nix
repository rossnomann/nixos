{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  package = pkgs.gimp3-with-plugins.override {
    plugins = [ pkgs.gimp3Plugins.gmic ];
  };
in
{
  options.nih.programs.graphics.gimp = {
    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.programs.graphics.gimp.executable = "${package}/bin/gimp";
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
