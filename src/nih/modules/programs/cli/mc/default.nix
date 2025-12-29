{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgPrograms = cfg.programs;
  c = import ./config.nix lib;
  package = pkgs.mc.overrideAttrs (
    old:
    let
      pathConfigIni = pkgs.writeText "mc.ini" (
        c.mkIni {
          general = c.defaults.ini.general // {
            skin = "catppuccin";
          };
        }
      );
      pathConfigExtIni =
        let
          nohupXdgOpen = pkgs.writeShellScriptBin "nohup-xdg-open" ''
            ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
          '';
        in
        pkgs.writeText "mc.ext.ini" (
          c.mkExtIni {
            xdgOpen = "${nohupXdgOpen}/bin/nohup-xdg-open";
            editRasterImage = cfgPrograms.graphics.gimp.executable;
            editVectorImage = cfgPrograms.graphics.inkscape.executable;
          }
        );
      pathDesktopEntry = pkgs.writeText "mc.desktop" ''
        [Desktop Entry]
        Type=Application
        Name=Midnight Commander
        Exec=${cfgPrograms.desktop.alacritty.runCommand} mc %U
      '';
    in
    {
      postInstall = (old.postInstall or "") + ''
        install -Dm444 ${pathConfigIni} $out/etc/mc/mc.ini
        install -Dm444 ${pathConfigExtIni} $out/etc/mc/mc.ext.ini
        install -Dm444 "${cfgSources.catppuccin-mc}/catppuccin.ini" $out/share/mc/skins/catppuccin.ini
        install -Dm444 ${pathDesktopEntry} $out/share/applications/mc.desktop
      '';
    }
  );
in
{
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/mc" ];
    environment.systemPackages = [ package ];
    nih.xdg.mime.directories = "mc.desktop";
  };
}
