{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.curl
    pkgs.file
    pkgs.htop
    pkgs.lshw
    pkgs.nixfmt-rfc-style
    pkgs.pciutils
    pkgs.trash-cli
    pkgs.usbutils
    pkgs.unrar
    pkgs.wget
  ];
}
