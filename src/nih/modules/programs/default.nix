{
  config,
  fretboard,
  lib,
  pkgs,
  pkgs20251111,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
  p = import ./packages.nix {
    inherit
      fretboard
      pkgs
      pkgs20251111
      cfgSources
      ;
  };
in
{
  options.nih.programs.desktop = {
    alacritty.executable = lib.mkOption { type = lib.types.str; };
    rofi.cmdShow = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.attrValues p;
    environment.variables = {
      MOZ_USE_XINPUT2 = "1";
    };
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    xdg.mime =
      let
        assoc = {
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        };
      in
      {
        addedAssociations = assoc;
        defaultApplications = assoc;
      };
    nih.graphicalSession.windowRules = [
      {
        appId = "^Alacritty";
        workspace = "terminal";
      }
      {
        appId = "^Ardour";
        workspace = "audio";
      }
      {
        appId = "^deadbeef";
        workspace = "secondary";
      }
      {
        appId = "^discord";
        workspace = "secondary";
      }
      {
        appId = "^firefox";
        workspace = "main";
      }
      {
        appId = "^gimp";
        workspace = "main";
      }
      {
        appId = ''^fr\\.greyc\\.$'';
        workspace = "main";
      }
      {
        appId = ''^org\\.pipewire\\.Helvum'';
        workspace = "audio";
      }
      {
        appId = ''^org\\.inkscape\\.Inkscape'';
        workspace = "main";
      }
      {
        appId = "^libreoffice";
        workspace = "main";
      }
      {
        appId = "^mpv";
        workspace = "main";
        fullscreen = true;
      }
      {
        appId = "^obsidian";
        workspace = "main";
      }
      {
        appId = "^Slack";
        workspace = "secondary";
      }
      {
        appId = "^steam";
        fullscreen = true;
        workspace = "games";
      }
      {
        appId = "^syncplay";
        workspace = "main";
        floating = true;
      }
      {
        appId = ''^org\\.telegram\\.desktop'';
        workspace = "secondary";
      }
      {
        appId = "^transmission";
        workspace = "main";
      }
      {
        appId = ''^org\\.pwmt\\.zathura'';
        workspace = "main";
      }
    ];
    nih = {
      programs.desktop = {
        alacritty.executable = "${p.alacritty}/bin/alacritty";
        rofi.cmdShow = [
          "${p.rofi}/bin/rofi"
          "-show"
          "combi"
        ];
      };
      user.home.file =
        let
          inherit (cfgStyle) palette;
        in
        {

          ".config/alacritty/alacritty.toml".text = import ./resources/alacritty.nix {
            fontMonospace = cfgStyle.fonts.monospace;
            themePath = "${cfgSources.catppuccin-alacritty}/catppuccin-${cfgStyle.palette.variant}.toml";
          };
          ".config/ardour8/my-dark-ardour-8.12.colors".source = ./resources/ardour.colors;
          ".config/fretboard/config.toml".text = import ./resources/fretboard.nix palette;
          ".config/macchina/macchina.toml".source = ./resources/macchina-config.toml;
          ".config/macchina/themes/default.toml".source = ./resources/macchina-theme.toml;
          ".config/mc/ini".source = ./resources/mc.ini;
          ".config/mc/mc.ext.ini".text =
            let
              xdgOpen = "${p.nohupXdgOpen}/bin/nohup-xdg-open";
            in
            lib.generators.toINI { } {
              "mc.ext.ini" = {
                Version = 4.0;
              };
              Default = {
                Open = "${xdgOpen} %d/%p";
                View = "${xdgOpen} %d/%p";
              };
            };
          ".config/mpv/mpv.conf".text =
            let
              theme = builtins.readFile "${p.mpvCatppuccin}/${palette.variant}/${palette.accent}.conf";
            in
            ''
              ${theme}
            '';
          ".config/rofi/config.rasi".text = import ./resources/rofi.nix cfgStyle.fonts.monospace.defaultSize;
          ".config/rofi/theme.rasi".source = "${cfgSources.catppuccin-rofi}/catppuccin-default.rasi";
          ".config/rofi/palette.rasi".source =
            "${cfgSources.catppuccin-rofi}/themes/catppuccin-${cfgStyle.palette.variant}.rasi";
          ".config/zathura/zathurarc".text = ''
            include ${cfgSources.catppuccin-zathura}/themes/catppuccin-${cfgStyle.palette.variant}
          '';
          ".local/share/mc/skins/catppuccin.ini".source = "${cfgSources.catppuccin-mc}/catppuccin.ini";
        };
      xdg.mime = {
        archives = "xarchiver.desktop";
        audio = "mpv.desktop";
        documents = "org.pwmt.zathura.desktop";
        images = "org.gnome.Loupe.desktop";
        torrents = "transmission-gtk.desktop";
        videos = "mpv.desktop";
      };
    };
  };
}
