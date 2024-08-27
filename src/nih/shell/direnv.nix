{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.direnv
      pkgs.nix-direnv
    ];
    home-manager.users.${cfgUser.name} = {
      xdg.configFile = {
        "direnv/direnv.toml".text = ''
          [global]
          hide_env_diff = true
          warn_timeout = 0
        '';
        "direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
      };
    };
  };
}
