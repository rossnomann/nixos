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
  options.nih.programs.cli.macchina = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.macchina.package ];
    nih.programs.cli.macchina.executable = "${cfgPrograms.cli.macchina.package}/bin/macchina";
    nih.programs.cli.macchina.package = pkgs.macchina;
    nih.user.home.file = {
      ".config/macchina/macchina.toml".text = lib.nih.gen.macchina.mkConfig { };
      ".config/macchina/themes/default.toml".text = lib.nih.gen.macchina.mkTheme { };
    };
  };
}
