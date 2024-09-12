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
  options.nih.programs.cli.curl = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.curl.package ];
    nih.programs.cli.curl.executable = "${cfgPrograms.cli.curl.package}/bin/curl";
    nih.programs.cli.curl.package = pkgs.curl;
  };
}
