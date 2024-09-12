{ config, lib, ... }:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
