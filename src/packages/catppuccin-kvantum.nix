{ src, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  inherit src;
  pname = "catppuccin-kvantum";
  version = src.revision;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -a themes/* $out/share/Kvantum
    runHook postInstall
  '';
}
