{ lib, ... }:
{
  imports = [
    ./programs
    ./services
    ./tablet.nix
  ];
  options.nih.gui.x11 = {
    autorandr.profiles = lib.mkOption { type = lib.types.attrs; };
    tablet.enable = lib.mkEnableOption "Tablet mode support";
  };
}
