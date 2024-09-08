{ lib, ... }:
{
  imports = [
    ./config.nix
    ./screenshot.nix
    ./tablet.nix
  ];
  options.nih.gui.x11 = {
    autorandr.profiles = lib.mkOption { type = lib.types.attrs; };
    tablet.enable = lib.mkEnableOption "Tablet mode support";
    wm = {
      gutterSize = lib.mkOption { type = lib.types.int; };
      marginSize = lib.mkOption { type = lib.types.int; };
    };
  };
}
