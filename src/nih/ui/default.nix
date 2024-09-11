{ lib, ... }:
{
  imports = [
    ./programs
    ./services
    ./style
    ./x11
  ];
  options.nih.ui = {
    dpi = lib.mkOption { type = lib.types.int; };
  };
}
