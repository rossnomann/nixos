{ lib, writeTextFile }:
let
  leftwm = import ./leftwm.nix { inherit lib; };
  mime = import ./mime.nix;
  paths = import ./paths.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
  store = import ./store.nix { inherit lib writeTextFile; };
in
{
  nih = {
    inherit
      leftwm
      mime
      paths
      strings
      store
      ;
  };
}
