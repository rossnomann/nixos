{ lib, ... }:
{
  imports = [
    ./x11
  ];
  options.nih.ui = {
    dpi = lib.mkOption { type = lib.types.int; };
  };
}
