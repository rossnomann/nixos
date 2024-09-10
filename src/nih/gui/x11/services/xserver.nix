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
    environment.systemPackages = [ pkgs.sx ];
    nih = {
      login.command = "'sx'";
      user.home.file = {
        ".config/sx/sxrc" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
                eval $(dbus-launch --exit-with-session --sh-syntax)
            fi
            systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
            dbus-update-activation-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
            xrdb -merge ~/.config/sx/xresources
            systemctl --user start wm-session.target
            exec leftwm
          '';
        };
        ".config/sx/xresources".text =
          let
            palette = cfgPalette.current;
          in
          ''
            Xcursor.size: ${builtins.toString cfgGui.style.cursors.size}
            Xcursor.theme: ${cfgGui.style.cursors.name}

            Xft.autohint: 0
            Xft.dpi: ${builtins.toString cfgGui.dpi}
            Xft.lcdfilter: lcddefault
            Xft.hintstyle: hintfull
            Xft.hinting: 1
            Xft.antialias: 1
            Xft.rgba: rgb

            *background: ${palette.base}
            *foreground: ${palette.text}

            ! black
            *color0: ${palette.surface1}
            *color8: ${palette.surface2}

            ! red
            *color1: ${palette.red}
            *color9: ${palette.red}

            ! green
            *color2: ${palette.green}
            *color10: ${palette.green}

            ! yellow
            *color3: ${palette.yellow}
            *color11: ${palette.yellow}

            ! blue
            *color4: ${palette.blue}
            *color12: ${palette.blue}

            ! magenta
            *color5: ${palette.pink}
            *color13: ${palette.pink}

            ! cyan
            *color6: ${palette.teal}
            *color14: ${palette.teal}

            ! white
            *color7: ${palette.subtext1}
            *color15: ${palette.subtext0}
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
