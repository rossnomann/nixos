{ src, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  inherit src;
  pname = "catppuccin-mpv";
  version = src.revision;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    find themes/*.conf -type f -exec sed -i "s/^background-color=.*$/background-color=\'#000000\'/g" {} +
    cp -a themes/* $out
    runHook postInstall
  '';
}
