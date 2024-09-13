{ config, lib, ... }:
let
  cfg = config.nih;
  cfgNet = cfg.net;
  cfgUser = cfg.user;
in
{
  options.nih.net.host = lib.mkOption { type = lib.types.str; };
  config = lib.mkIf cfg.enable {
    networking.hostName = cfgNet.host;
    networking.nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "1.0.0.1"
    ];
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;
    users.users.${cfgUser.name}.extraGroups = [ "networkmanager" ];
  };
}
