{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUi = cfg.ui;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sx ];
    nih = {
      login.command = "'sx'";
      user.home.file = {
        ".config/sx/sxrc" = {
          executable = true;
          text =
            let
              wm = cfgUi.x11.wm.executable;
            in
            ''
              #!/usr/bin/env bash
              if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
                  eval $(dbus-launch --exit-with-session --sh-syntax)
              fi
              systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
              dbus-update-activation-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
              xrdb -merge ~/.config/sx/xresources
              systemctl --user start wm-session.target
              exec ${wm}
            '';
        };
        ".config/sx/xresources".text =
          let
            colors = cfgPalette.colors;
          in
          ''
            Xcursor.size: ${builtins.toString cfgUi.style.cursors.size}
            Xcursor.theme: ${cfgUi.style.cursors.name}

            Xft.autohint: 0
            Xft.dpi: ${builtins.toString cfgUi.dpi}
            Xft.lcdfilter: lcddefault
            Xft.hintstyle: hintfull
            Xft.hinting: 1
            Xft.antialias: 1
            Xft.rgba: rgb

            *background: ${colors.base}
            *foreground: ${colors.text}

            ! black
            *color0: ${colors.surface1}
            *color8: ${colors.surface2}

            ! red
            *color1: ${colors.red}
            *color9: ${colors.red}

            ! green
            *color2: ${colors.green}
            *color10: ${colors.green}

            ! yellow
            *color3: ${colors.yellow}
            *color11: ${colors.yellow}

            ! blue
            *color4: ${colors.blue}
            *color12: ${colors.blue}

            ! magenta
            *color5: ${colors.pink}
            *color13: ${colors.pink}

            ! cyan
            *color6: ${colors.teal}
            *color14: ${colors.teal}

            ! white
            *color7: ${colors.subtext1}
            *color15: ${colors.subtext0}
          '';
      };
    };
    services.xserver = {
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
    systemd.user.units."wm-session.target" = {
      name = "wm-session.target";
      enable = true;
      text = ''
        [Unit]
        Description=A window manager session
        Documentation=man:systemd.special
        BindsTo=graphical-session.target
        Wants=graphical-session-pre.target
        After=graphical-session-pre.target nixos-activation.service
      '';
    };
  };
}
