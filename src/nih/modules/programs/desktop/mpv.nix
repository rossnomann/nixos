{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mpv ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^mpv'';
        workspace = "main";
        fullscreen = true;
      }
    ];
    nih.xdg.mime =
      let
        entry = "mpv.desktop";
      in
      {
        audio = entry;
        videos = entry;
      };
    nih.user.home.file = {
      ".config/mpv/mpv.conf".text =
        let
          src = cfgSources.catppuccin-mpv;
          package = pkgs.stdenvNoCC.mkDerivation {
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
          };
          palette = cfgStyle.palette;
          theme = builtins.readFile "${package}/${palette.variant}/${palette.accent}.conf";
        in
        ''
          ${theme}
        '';
    };
  };
}
