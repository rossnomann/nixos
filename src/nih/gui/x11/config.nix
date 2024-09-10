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
      pkgs.arandr
      pkgs.greetd.greetd
      pkgs.greetd.tuigreet
      pkgs.hsetroot
      pkgs.leftwm
      pkgs.picom
      pkgs.sx
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xorg.xdpyinfo
      pkgs.xorg.xkill
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
          ".config/picom/picom.conf".source = ./resources/picom/picom.conf;
          ".config/sx/sxrc".source = ./resources/sx/sxrc;
          ".config/sx/xresources".text = (
            import ./resources/sx/xresources.nix {
              inherit palette;
              dpi = cfgGui.dpi;
              cursorSize = cfgGui.style.cursors.size;
              cursorThemeName = cfgGui.style.cursors.name;
            }
          );
        };
    };
    services = {
      autorandr = {
        enable = true;
        hooks.postswitch."dpi" = ''
          xrandr --dpi ${builtins.toString cfgGui.dpi}
          leftwm command SoftReload
        '';
        ignoreLid = true;
        profiles = cfgGui.x11.autorandr.profiles;
      };
      greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd 'sx'";
      };
      libinput.enable = true;

      xserver = {
        enable = true;
        autorun = false;
        exportConfiguration = true;
        excludePackages = [
          pkgs.xorg.xinit
          pkgs.xterm
        ];
        extraConfig = ''
          Section "Extensions"
            Option "DPMS" "false"
          EndSection
        '';
        serverFlagsSection = ''
          Option "BlankTime" "0"
          Option "StandbyTime" "0"
          Option "SuspendTime" "0"
          Option "OffTime" "0"
        '';
        xkb = {
          layout = "us,ru";
          options = "grp:win_space_toggle";
          variant = "qwerty";
        };
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
