{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.curl
    pkgs.gnupg
    pkgs.htop
    pkgs.lshw
    pkgs.nixfmt-rfc-style
    pkgs.pciutils
    pkgs.usbutils
    pkgs.wget
  ];
}
