{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "wallpapers";
  src = ./resources;
  version = "0.0.0";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/wallpapers/nih
    cp -a default.jpg $out/share/wallpapers/nih/default.jpg
    runHook postInstall
  '';
}
