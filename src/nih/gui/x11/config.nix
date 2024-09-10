{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.hsetroot
      pkgs.leftwm
    ];
    nih = {
      gui.services.dunst =
        let
          gutter = cfgGui.x11.wm.gutterSize;
        in
        {
          gap = gutter;
          offset = gutter * 2;
        };
      user.home.file =
        let
          palette = cfgPalette.current;
        in
        {
          ".config/leftwm/config.ron".source = ./resources/leftwm/config.ron;
          ".config/leftwm/down".source = ./resources/leftwm/down;
          ".config/leftwm/up".source = ./resources/leftwm/up;
          ".config/leftwm/themes/current/down".source = ./resources/leftwm/themes/current/down;
          ".config/leftwm/themes/current/theme.ron".text = (
            import ./resources/leftwm/themes/current/theme.nix {
              inherit palette;
              wm = cfgGui.x11.wm;
            }
          );
          ".config/leftwm/themes/current/up".source = ./resources/leftwm/themes/current/up;
        };
    };

    systemd.user.units."leftwm-session.target" = {
      name = "leftwm-session.target";
      enable = true;
      text = ''
        [Unit]
        Description=LeftWM session
        Documentation=man:systemd.special
        BindsTo=graphical-session.target
        Wants=graphical-session-pre.target
        After=graphical-session-pre.target nixos-activation.service
      '';
    };
  };
}
