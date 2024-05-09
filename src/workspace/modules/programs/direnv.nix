{ config, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = {
        global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };
    };
  };
}
