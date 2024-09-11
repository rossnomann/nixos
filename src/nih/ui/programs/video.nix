{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUi = cfg.ui;
in
{
  options.nih.ui.programs.video.mpv.theme.package = lib.mkOption { type = lib.types.package; };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mpv
      pkgs.kdePackages.kdenlive
      pkgs.syncplay
    ];
    nih = {
      ui = {
        programs.video.mpv.theme.package = pkgs.stdenvNoCC.mkDerivation {
          pname = "catppuccin-mpv";
          version = npins.catppuccin-mpv.revision;
          src = npins.catppuccin-mpv;
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            find themes/*.conf -type f -exec sed -i "s/^background-color=.*$/background-color=\'#000000\'/g" {} +
            cp -a themes/* $out
            runHook postInstall
          '';
        };
        x11.wm.windowRules = [
          {
            windowClass = "mpv";
            spawnFullscreen = true;
            spawnOnTag = "secondary";
          }
          {
            windowClass = ".syncplay-wrapped";
            spawnFloating = true;
            spawnOnTag = "secondary";
          }
        ];
      };
      xdg.mime =
        let
          entry = "mpv.desktop";
        in
        {
          audio = entry;
          videos = entry;
        };
      user.home.file = {
        ".config/mpv/mpv.conf".source =
          let
            package = cfgUi.programs.video.mpv.theme.package;
          in
          "${package}/${cfgPalette.variant}/${cfgPalette.accent}.conf";
      };
    };
  };
}
