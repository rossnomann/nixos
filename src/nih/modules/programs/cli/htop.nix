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
  options.nih.programs.cli.htop = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.htop.package ];
    nih.programs.cli.htop.executable = "${cfgPrograms.cli.htop.package}/bin/htop";
    nih.programs.cli.htop.package = pkgs.htop;
  };
}
