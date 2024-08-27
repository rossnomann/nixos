{ lib, ... }:
{
  imports = [
    ./gui
    ./shell
    ./audio.nix
    ./console.nix
    ./locale.nix
    ./net.nix
    ./nixos.nix
    ./palette.nix
    ./power.nix
    ./services.nix
    ./sync.nix
    ./user.nix
    ./vt.nix
    ./xdg.nix
  ];
  options.nih = {
    enable = lib.mkEnableOption "NIH";
  };
}
