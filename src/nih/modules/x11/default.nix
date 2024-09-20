{ lib, ... }:
{
  imports = [
    ./programs
    ./services
  ];
  options.nih.x11 = {
    enable = lib.mkEnableOption "X11";
    autorandr.profiles = lib.mkOption { type = lib.types.attrs; };
    dpi = lib.mkOption { type = lib.types.int; };
  };
}
