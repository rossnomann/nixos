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
  options.nih.programs.cli.wget = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.wget.package ];
    nih.programs.cli.wget.executable = "${cfgPrograms.cli.wget.package}/bin/wget";
    nih.programs.cli.wget.package = pkgs.wget;
  };
}
