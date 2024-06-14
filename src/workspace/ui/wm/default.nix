{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.arandr
    pkgs.greetd.greetd
    pkgs.greetd.tuigreet
    pkgs.hsetroot
    pkgs.leftwm
    pkgs.picom
    pkgs.rlaunch
    pkgs.sx
    pkgs.wmctrl
    pkgs.xclip
    pkgs.xorg.xdpyinfo
    pkgs.xorg.xkill
  ];
  home-manager.users.${config.workspace.user.name} = {
    home.file.".local/bin/rlaunch-wrapper".source = ./resources/rlaunch/wrapper.nu;
    xdg = {
      configFile =
        let
          ui = config.workspace.ui;
          palette = ui.palette;
          wm = ui.wm;
        in
        {
          "leftwm/config.ron".source = ./resources/leftwm/config.ron;
          "leftwm/down".source = ./resources/leftwm/down;
          "leftwm/up".source = ./resources/leftwm/up;
          "leftwm/themes/current/down".source = ./resources/leftwm/themes/current/down;
          "leftwm/themes/current/theme.ron".text = (
            import ./resources/leftwm/themes/current/theme.nix {
              inherit palette;
              inherit wm;
            }
          );
          "leftwm/themes/current/up".source = ./resources/leftwm/themes/current/up;
          "picom/picom.conf".source = ./resources/picom/picom.conf;
          "rlaunch/args".text = (
            lib.concatStringsSep " " (import ./resources/rlaunch/args.nix { inherit ui; })
          );
          "sx/sxrc".source = ./resources/sx/sxrc;
          "sx/xresources".text = (import ./resources/sx/xresources.nix { inherit ui; });
          "systemd/user/leftwm-session.target".source = ./resources/systemd/leftwm-session.target;
        };
      dataFile = {
        "backgrounds/default.jpg".source = ./resources/backgrounds/default.jpg;
        "backgrounds/default-empty.jpg".source = ./resources/backgrounds/default-empty.jpg;
      };
    };
  };
  services = {
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
}
