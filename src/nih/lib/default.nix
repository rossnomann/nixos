{ lib }:
let
  catppuccin = import ./catppuccin.nix;
  leftwm = import ./leftwm.nix { inherit lib; };
  mime = import ./mime.nix;
  mc = import ./mc.nix { inherit lib; };
  paths = import ./paths.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
in
{
  nih = {
    inherit
      catppuccin
      leftwm
      mc
      mime
      paths
      strings
      ;
  };
}
