{ lib, ... }:
{
  imports = [
    ./programs
    ./style
    ./x11
  ];
  options.nih.gui = {
    dpi = lib.mkOption { type = lib.types.int; };
  };
}
