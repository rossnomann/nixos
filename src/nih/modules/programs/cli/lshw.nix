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
  options.nih.programs.cli.lshw = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.lshw.package ];
    nih.programs.cli.lshw.executable = "${cfgPrograms.cli.lshw.package}/bin/lshw";
    nih.programs.cli.lshw.package = pkgs.lshw;
  };
}
