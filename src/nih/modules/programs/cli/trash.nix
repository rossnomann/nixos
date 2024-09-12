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
  options.nih.programs.cli.trash = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.trash.package ];
    nih.programs.cli.trash.executable = "${cfgPrograms.cli.trash.package}/bin/trash";
    nih.programs.cli.trash.package = pkgs.trash-cli;
  };
}
