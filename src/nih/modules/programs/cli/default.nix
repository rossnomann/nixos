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
  imports = [
    ./bat.nix
    ./direnv.nix
    ./git.nix
    ./gnupg.nix
    ./helix.nix
    ./less.nix
    ./macchina.nix
    ./mc.nix
  ];
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.android-tools
      pkgs.curl
      pkgs.exiftool
      pkgs.file
      pkgs.htop
      pkgs.imagemagick
      pkgs.lame
      pkgs.lshw
      pkgs.mergiraf
      pkgs.pciutils
      pkgs.trash-cli
      pkgs.unrar
      pkgs.usbutils
      pkgs.wget
    ];
  };
}
