{ lib, ... }:
{
  imports = [
    ./niri
    ./kickoff.nix
  ];
  options.nih.wayland = {
    enable = lib.mkEnableOption "Wayland";
  };
}
