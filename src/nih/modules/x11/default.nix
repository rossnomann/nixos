{ lib, ... }:
{
  imports = [
    ./programs
    ./services
    ./tablet.nix
  ];
  options.nih.x11 = {
    enable = lib.mkEnableOption "X11";
    autorandr.profiles = lib.mkOption { type = lib.types.attrs; };
    dpi = lib.mkOption { type = lib.types.int; };
    tablet.enable = lib.mkEnableOption "Tablet mode support";
  };
}
