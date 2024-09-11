{ prev }:
{
  arguments,
  shellPath,
}:
prev.callPackage ./package.nix {
  inherit
    arguments
    shellPath
    ;
}
