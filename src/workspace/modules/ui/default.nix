{ config, pkgs, ... }:
{
  boot.kernelParams = [
    "splash"
    "quiet"
    "loglevel=3"
    "udev.log_level=3"
  ];

  console =
    let
      getColor = value: builtins.substring 1 (-1) value;
      palette = config.workspace.theme.palette;
    in
    {
      colors = map getColor [
        palette.base
        palette.red
        palette.green
        palette.yellow
        palette.blue
        palette.pink
        palette.teal
        palette.subtext1
        palette.surface2
        palette.red
        palette.green
        palette.yellow
        palette.blue
        palette.pink
        palette.teal
        palette.subtext0
      ];
      earlySetup = true;
    };

  environment = {
    # Lock dconf settings.
    # Note that you need to run
    # dconf update as root
    # to create the /etc/dconf/db/local file.
    etc."dconf/profile/user".text = ''
      user-db:user
      system-db:local
    '';
    etc."dconf/db/local.d/00-filechooser".text = ''
      [org/gtk/settings/file-chooser]
      window-size=(800, 500)
    '';
    etc."dconf/db/local.d/locks/00-filechooser".text = ''
      /org/gtk/settings/file-chooser/window-size
    '';

    systemPackages = [
      pkgs.arandr
      pkgs.greetd.greetd
      pkgs.greetd.tuigreet
      pkgs.hsetroot
      pkgs.leftwm
      pkgs.libnotify
      pkgs.rlaunch
      pkgs.shotgun
      pkgs.slop
      pkgs.sx
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xorg.xdpyinfo
    ];
  };

  fonts = {
    packages = [
      pkgs.roboto
      pkgs.roboto-serif
      pkgs.fira-code
      pkgs.fira-code-symbols
    ];
    fontconfig = {
      enable = true;

      defaultFonts =
        let
          font = config.workspace.theme.font;
        in
        {
          monospace = [ font.monospace.family ];
          sansSerif = [ font.sansSerif.family ];
          serif = [ font.serif.family ];
        };
    };
  };

  programs.dconf.enable = true;

  services = {
    greetd = {
      enable = true;

      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd 'sx'";
        };
      };
    };
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
      libinput.enable = true;
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
      xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle";
      };
    };
  };

  home-manager.users.${config.workspace.user.name} = {
    gtk =
      let
        extraCss = ''
          * {
            border-radius: 0 0 0 0;
            box-shadow: none;
          }
        '';
        extraConfig = {
          gtk-decoration-layout = ":";
        };
      in
      {
        enable = true;

        font =
          let
            fontSansSerif = config.workspace.theme.font.sansSerif;
          in
          {
            name = fontSansSerif.family;
            size = fontSansSerif.defaultSize;
          };
        gtk2.configLocation =
          let
            homeDirectory = config.home-manager.users.${config.workspace.user.name}.home.homeDirectory;
          in
          "${homeDirectory}/.config/gtk-2.0/gtkrc";
        gtk3.extraConfig = extraConfig;
        gtk3.extraCss = extraCss;
        gtk4.extraConfig = extraConfig;
        gtk4.extraCss = extraCss;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        theme = {
          name = "Catppuccin-Mocha-Compact-Green-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "green" ];
            size = "compact";
            tweaks = [ "rimless" ];
            variant = "mocha";
          };
        };
      };

    home = {
      file.".local/bin".source = ./resources/bin;
      packages = [
        (pkgs.catppuccin-kvantum.override {
          accent = "Green";
          variant = "Mocha";
        })
      ];
      pointerCursor = {
        gtk.enable = true;
        x11.enable = false;

        name = "Catppuccin-Mocha-Green-Cursors";
        package = pkgs.catppuccin-cursors.mochaGreen;
        size = 16;
      };
    };

    qt = {
      enable = true;

      platformTheme.name = "adwaita";
      style.name = "kvantum";
    };

    services = {
      dunst = {
        enable = true;

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        settings =
          let
            fontSansSerif = config.workspace.theme.font.sansSerif;
            palette = config.workspace.theme.palette;
          in
          {
            global = {
              background = palette.base;
              font = "${fontSansSerif.family} ${builtins.toString fontSansSerif.defaultSize}";
              follow = "keyboard";
              foreground = palette.text;
              frame_color = palette.green;
              frame_width = 1;
              gap_size = 12;
              offset = "24x24";
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
      picom = {
        enable = true;

        backend = "glx";
        fade = true;
        settings = {
          vsync = true;
        };
      };
    };

    xdg = {
      configFile = {
        "leftwm/config.ron".source = ./resources/config/leftwm/config.ron;
        "leftwm/down".source = ./resources/config/leftwm/down;
        "leftwm/up".source = ./resources/config/leftwm/up;
        "leftwm/themes/current".source = ./resources/config/leftwm/themes/current;
        "sx".source = ./resources/config/sx;
        "Kvantum/kvantum.kvconfig".source = ./resources/config/kvantum/kvconfig;
        "rlaunch".source = ./resources/config/rlaunch;
        "systemd/user/leftwm-session.target".source = ./resources/config/systemd/user/leftwm-session.target;
      };
      dataFile = {
        "backgrounds/default.jpg".source = ./resources/data/backgrounds/default.jpg;
        "backgrounds/default-empty.jpg".source = ./resources/data/backgrounds/default-empty.jpg;
      };
    };
  };

  workspace.theme.font =
    let
      defaultSize = 10;
    in
    {
      monospace = {
        family = "Fira Code";
        inherit defaultSize;
      };
      sansSerif = {
        family = "Roboto";
        inherit defaultSize;
      };
      serif = {
        family = "Roboto Serif";
        inherit defaultSize;
      };
    };

  xdg.portal = {
    enable = true;

    config.common.default = [ "gtk" ];
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
