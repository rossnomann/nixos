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
      pkgs.htop
      pkgs.lshw
      pkgs.pciutils
      pkgs.usbutils
    ];
  };
}
