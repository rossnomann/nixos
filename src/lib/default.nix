{ lib, writeTextFile }:
let
  mime = import ./mime.nix;
  paths = import ./paths.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
  store = import ./store.nix { inherit lib writeTextFile; };
in
{
  nih = {
    inherit
      mime
      paths
      strings
      store
      ;
  };
}
