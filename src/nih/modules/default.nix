{ lib, ... }:
{
  imports = [
    ./programs
    ./services
    ./shell
    ./x11
    ./audio.nix
    ./bluetooth.nix
    ./console.nix
    ./locale.nix
    ./login.nix
    ./net.nix
    ./nixos.nix
    ./power.nix
    ./style.nix
    ./sync.nix
    ./user.nix
    ./vt.nix
    ./xdg.nix
  ];
  options.nih = {
    enable = lib.mkEnableOption "NIH";
  };
}
