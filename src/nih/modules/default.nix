{ lib, ... }:
{
  imports = [
    ./dev
    ./xdg
    ./graphical-session
    ./programs
    ./sources
    ./audio.nix
    ./bluetooth.nix
    ./console.nix
    ./locale.nix
    ./login.nix
    ./net.nix
    ./nixos.nix
    ./power.nix
    ./services.nix
    ./style.nix
    ./sync.nix
    ./user.nix
  ];
  options.nih = {
    enable = lib.mkEnableOption "NIH";
  };
}
