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
  options.nih.programs.cli.file = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.file.package ];
    nih.programs.cli.file.executable = "${cfgPrograms.cli.file.package}/bin/file";
    nih.programs.cli.file.package = pkgs.file;
  };
}
