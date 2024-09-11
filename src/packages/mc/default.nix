{ prev }:
{
  commandTerminal,
  configIni,
  configExtIni,
  pathSkin,
}:
prev.callPackage ./package.nix {
  inherit
    commandTerminal
    configIni
    configExtIni
    pathSkin
    ;
  mc = prev.mc;
}
