{
  commandTerminal,
  configIni,
  configExtIni,
  pathSkin,
  writeText,
  mc,
}:
mc.overrideAttrs (
  old:
  let
    pathConfigIni = writeText "mc.ini" configIni;
    pathConfigExtIni = writeText "mc.ext.ini" configExtIni;
    pathDesktopEntry = writeText "mc.desktop" ''
      [Desktop Entry]
      Type=Application
      Name=Midnight Commander
      Exec=${commandTerminal} mc %U
    '';
  in
  {
    postInstall = (old.postInstall or "") + ''
      install -Dm444 ${pathConfigIni} $out/etc/mc/mc.ini
      install -Dm444 ${pathConfigExtIni} $out/etc/mc/mc.ext.ini
      install -Dm444 ${pathSkin} $out/share/mc/skins/catppuccin.ini
      install -Dm444 ${pathDesktopEntry} $out/share/applications/mc.desktop
    '';
  }
)
