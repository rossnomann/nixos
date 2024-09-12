{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  package = pkgs.nih.x11-screenshot cfgPrograms.nushell.executable;
  executable = "${package}/bin/screenshot";
in
{
  options.nih.x11.programs.screenshot = {
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
    executable = lib.mkOption {
      type = lib.types.str;
      default = executable;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
  };
}
