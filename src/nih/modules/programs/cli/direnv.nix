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
  options.nih.programs.cli.direnv = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.direnv.package ];
    nih.programs.cli.direnv.package = pkgs.direnv;
    nih.programs.cli.git.ignore = [
      ".direnv"
      ".envrc"
    ];
    nih.user.home.file = {
      ".config/direnv/direnv.toml".text = ''
        [global]
        hide_env_diff = true
        warn_timeout = 0
      '';
      ".config/direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
  };
}
