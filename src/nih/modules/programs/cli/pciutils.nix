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
  options.nih.programs.cli.pciutils = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.pciutils.package ];
    nih.programs.cli.pciutils.executable = "${cfgPrograms.cli.pciutils.package}/bin/lspci";
    nih.programs.cli.pciutils.package = pkgs.pciutils;
  };
}
