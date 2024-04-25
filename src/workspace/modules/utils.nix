{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.curl
    pkgs.gnupg
    pkgs.htop
    pkgs.lshw
    pkgs.nixfmt-rfc-style
    pkgs.pinentry
    pkgs.pciutils
    pkgs.trash-cli
    pkgs.usbutils
    pkgs.wget
  ];
}
