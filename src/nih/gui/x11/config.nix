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
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.arandr
      pkgs.greetd.greetd
      pkgs.greetd.tuigreet
      pkgs.hsetroot
      pkgs.leftwm
      pkgs.libnotify
      pkgs.picom
      pkgs.rlaunch
      pkgs.shotgun
      pkgs.slop
      pkgs.sx
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xorg.xdpyinfo
      pkgs.xorg.xkill
    ];
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

    home-manager.users.${cfgUser.name} = {
      home.file =
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
          ".config/rlaunch/args".text = (
            lib.concatStringsSep " " (
              import ./resources/rlaunch/args.nix {
                inherit palette;
                font = cfgGui.style.fonts.sansSerif;
              }
            )
          );
          ".config/sx/sxrc".source = ./resources/sx/sxrc;
          ".config/sx/xresources".text = (
            import ./resources/sx/xresources.nix {
              inherit palette;
              dpi = cfgGui.dpi;
              cursorSize = cfgGui.style.cursors.size;
              cursorThemeName = cfgGui.style.cursors.name;
            }
          );
          ".config/systemd/user/leftwm-session.target".source = ./resources/systemd/leftwm-session.target;
          ".local/bin/rlaunch-wrapper".source = ./resources/rlaunch/wrapper.nu;
          ".local/bin/screenshot".source = ./resources/screenshot;
        };
      services = {
        batsignal.enable = true;
        dunst = {
          enable = true;
          iconTheme =
            let
              iconTheme = cfgGui.style.icons;
            in
            {
              name = iconTheme.name;
              package = iconTheme.package;
            };
          settings =
            let
              font = cfgGui.style.fonts.sansSerif;
              palette = cfgPalette.current;
              wm = cfgGui.x11.wm;
              globalOffset = builtins.toString (wm.gutterSize * 2);
            in
            {
              global = {
                background = palette.base;
                font = "${font.family} ${builtins.toString font.defaultSize}";
                follow = "keyboard";
                foreground = palette.text;
                frame_color = palette.green;
                frame_width = 1;
                gap_size = wm.gutterSize;
                offset = "${globalOffset}x${globalOffset}";
                origin = "top-right";
              };
              urgency_low = {
                frame_color = palette.blue;
              };
              urgency_critical = {
                frame_color = palette.red;
              };
            };
        };
      };
    };
  };
}
