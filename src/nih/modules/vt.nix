{ config, lib, ... }:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${cfgUser.name}.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;
  };
}
