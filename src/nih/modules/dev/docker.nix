{ config, lib, ... }:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.variables = {
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    };
    users.users.${cfgUser.name}.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;
  };
}
