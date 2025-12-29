{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  package = pkgs.inkscape;
in
{
  options.nih.programs.graphics.inkscape = {
    executable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.programs.graphics.inkscape.executable = "${package}/bin/inkscape";
    nih.graphicalSession.windowRules = [
      {
        appId = ''^org\\.inkscape\\.Inkscape'';
        workspace = "main";
      }
    ];
  };
}
