{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgX11 = cfg.x11;
in
{
  options.nih.x11.programs.screenshot = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgX11.programs.screenshot.package ];
    nih.x11.programs.screenshot.executable = "${cfgX11.programs.screenshot.package}/bin/screenshot";
    nih.x11.programs.screenshot.package = pkgs.nih.x11-screenshot cfgPrograms.cli.nushell.executable;
  };
}
