{ lib }:
{
  nih = {
    gen = import ./gen lib;
    catppuccin = import ./catppuccin.nix;
    mime = import ./mime.nix;
    strings = import ./strings.nix lib;
  };
}
