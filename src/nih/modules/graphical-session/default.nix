{ lib, ... }:
{
  imports = [
    ./niri
    ./xresources.nix
  ];
  options = {
    nih.graphicalSession.dpi = lib.mkOption { type = lib.types.int; };
  };
}
