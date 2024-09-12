{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.direnv
      pkgs.nix-direnv
    ];
    nih.programs.git.ignore = [
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
