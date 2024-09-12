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
  options.nih.programs.cli.usbutils = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.usbutils.package ];
    nih.programs.cli.usbutils.executable = "${cfgPrograms.cli.usbutils.package}/bin/lsusb";
    nih.programs.cli.usbutils.package = pkgs.usbutils;
  };
}
