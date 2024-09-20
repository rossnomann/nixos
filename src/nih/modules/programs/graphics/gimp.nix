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
    nih.programs.graphics.gimp.package = pkgs.gimp-with-plugins.override {
      plugins = [ pkgs.gimpPlugins.gmic ];
    };
    nih.windowRules = [
      {
        x11Class = ".gimp-2.10-wrapped_";
        waylandAppId = ".gimp-2.10-wrapped_";
        useWorkspace = "graphics";
      }
      {
        x11Class = "gmic_qt";
        waylandAppId = "gmic_qt";
        useWorkspace = "graphics";
      }
    ];
  };
}
