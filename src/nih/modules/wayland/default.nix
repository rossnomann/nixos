{ lib, ... }:
{
  imports = [
    ./programs
    ./compositor.nix
  ];
  options.nih.wayland = {
    enable = lib.mkEnableOption "Wayland";
  };
}
