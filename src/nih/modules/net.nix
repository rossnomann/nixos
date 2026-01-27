{ config, lib, ... }:
let
  cfg = config.nih;
  cfgNet = cfg.net;
  cfgUser = cfg.user;
in
{
  options.nih.net.host = lib.mkOption { type = lib.types.str; };
  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfgNet.host;
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
    };
    users.users.${cfgUser.name}.extraGroups = [ "networkmanager" ];
  };
}
