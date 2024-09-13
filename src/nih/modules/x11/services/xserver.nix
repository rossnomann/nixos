{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgX11 = cfg.x11;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sx ];
    nih.login.command = "'sx'";
    nih.user.home.file = {
      ".config/sx/sxrc" = {
        executable = true;
        text =
          let
            wm = cfgX11.wm.executable;
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
          colors = cfgStyle.palette.colors;
          gen = lib.nih.gen.xresources;
        in
        gen.mkXresources {
          xcursor = gen.mkXcursor {
            size = cfgStyle.cursors.size;
            theme = cfgStyle.cursors.name;
          };
          xft = gen.mkXft { dpi = cfgX11.dpi; };
          colors = gen.mkColors {
            background = colors.base;
            foreground = colors.text;
            black = colors.surface1;
            blackBold = colors.surface2;
            red = colors.red;
            redBold = colors.red;
            green = colors.green;
            greenBold = colors.green;
            yellow = colors.yellow;
            yellowBold = colors.yellow;
            blue = colors.blue;
            blueBold = colors.blue;
            magenta = colors.pink;
            magentaBold = colors.pink;
            cyan = colors.teal;
            cyanBold = colors.teal;
            white = colors.subtext1;
            whiteBold = colors.subtext0;
          };
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
