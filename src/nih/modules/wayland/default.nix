{ lib, ... }:
{
  imports = [
    ./niri
  ];
  options.nih.wayland = {
    enable = lib.mkEnableOption "Wayland";
  };
}
