{ deviceName, lib, ... }:
{
  networking = {
    hostName = deviceName;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}
