{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
  cfgUser = cfg.user;
in
{
  options.nih.gui.programs.video.mpv.theme.package = lib.mkOption {
    internal = true;
    type = lib.types.package;
  };
  config = lib.mkIf cfg.enable {
    nih.gui.programs.video.mpv.theme.package = pkgs.stdenvNoCC.mkDerivation {
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
    environment.systemPackages = [
      pkgs.mpv
      pkgs.kdePackages.kdenlive
      pkgs.syncplay
    ];
    nih.xdg.mime =
      let
        entry = "mpv.desktop";
      in
      {
        audio = entry;
        videos = entry;
      };
    home-manager.users.${cfgUser.name}.home.file = {
      ".config/mpv/mpv.conf".source =
        let
          package = cfgGui.programs.video.mpv.theme.package;
        in
        "${package}/${cfgPalette.variant}/${cfgPalette.accent}.conf";
    };
  };
}
