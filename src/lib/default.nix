{ lib, writeTextFile }:
let
  mime = import ./mime.nix;
  paths = import ./paths.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
  types = import ./types.nix {
    inherit lib writeTextFile;
    inherit (paths) mkStoreFileName;
  };
in
{
  nih = {
    inherit
      mime
      paths
      strings
      types
      ;
  };
}
