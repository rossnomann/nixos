{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.curl
    pkgs.htop
    pkgs.lshw
    pkgs.nixfmt-rfc-style
    pkgs.pciutils
    pkgs.trash-cli
    pkgs.usbutils
    pkgs.wget
  ];
}
