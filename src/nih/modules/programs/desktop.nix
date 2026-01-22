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
  p = {
    alacritty = pkgs.alacritty;
    firefox = (
      pkgs.firefox.override { extraPolicies = import ./resources/desktop/firefox-policies.nix; }
    );
    fretboard = fretboard.packages.${pkgs.stdenv.hostPlatform.system}.default;
    gimp = pkgs.gimp3-with-plugins.override {
      plugins = [ pkgs.gimp3Plugins.gmic ];
    };
    mpvCatppuccin =
      let
        src = cfgSources.catppuccin-mpv;
      in
      pkgs.stdenvNoCC.mkDerivation {
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
    obsidian =
      let
        obsidianHook = pkgs.writeTextFile {
          name = "obsidian-hook";
          text = ''
            #!${pkgs.python314}/bin/python
            import json
            from pathlib import Path

            PATH = Path("~/.config/obsidian/obsidian.json").expanduser()
            if PATH.exists():
                with PATH.open() as f:
                    data = json.load(f)
                    if isinstance(data, dict) and "vaults" in data:
                        vaults = data["vaults"]
                        for i in vaults.values():
                            i.pop("open", None)
                with PATH.open("w") as f:
                    json.dump(data, f)
          '';
          executable = true;
        };
      in
      (pkgs.obsidian.overrideAttrs (x: {
        postInstall = ''
          sed -i '1 a ${obsidianHook}' $out/bin/obsidian
        '';
      }));
    rofi = pkgs.rofi;
  };
in
{
  options.nih.programs.desktop = {
    alacritty.executable = lib.mkOption { type = lib.types.str; };
    rofi.cmdShow = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      p.alacritty
      p.firefox
      p.fretboard
      p.gimp
      p.obsidian
      p.rofi
      pkgs20251111.deadbeef
      pkgs.ardour
      pkgs.discord
      pkgs.helvum
      pkgs.inkscape
      pkgs.libreoffice
      pkgs.loupe
      pkgs.mpv
      pkgs.overskride
      pkgs.slack
      pkgs.scrcpy
      pkgs.simple-scan
      pkgs.syncplay
      pkgs.telegram-desktop
      pkgs.transmission_4-gtk
      pkgs.xarchiver
      pkgs.zathura
    ];
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
    nih.programs.desktop = {
      alacritty.executable = "${p.alacritty}/bin/alacritty";
      rofi.cmdShow = [
        "${p.rofi}/bin/rofi"
        "-show"
        "combi"
      ];
    };
    nih.user.home.file =
      let
        palette = cfgStyle.palette;
      in
      {

        ".config/alacritty/alacritty.toml".text = import ./resources/desktop/alacritty.nix {
          fontMonospace = cfgStyle.fonts.monospace;
          themePath = "${cfgSources.catppuccin-alacritty}/catppuccin-${cfgStyle.palette.variant}.toml";
        };
        ".config/ardour8/my-dark-ardour-8.12.colors".source = ./resources/desktop/ardour.colors;
        ".config/fretboard/config.toml".text = import ./resources/desktop/fretboard.nix palette;
        ".config/mpv/mpv.conf".text =
          let
            theme = builtins.readFile "${p.mpvCatppuccin}/${palette.variant}/${palette.accent}.conf";
          in
          ''
            ${theme}
          '';
        ".config/rofi/config.rasi".text =
          import ./resources/desktop/rofi.nix cfgStyle.fonts.monospace.defaultSize;
        ".config/rofi/theme.rasi".source = "${cfgSources.catppuccin-rofi}/catppuccin-default.rasi";
        ".config/rofi/palette.rasi".source =
          "${cfgSources.catppuccin-rofi}/themes/catppuccin-${cfgStyle.palette.variant}.rasi";
        ".config/zathura/zathurarc".text = ''
          include ${cfgSources.catppuccin-zathura}/themes/catppuccin-${cfgStyle.palette.variant}
        '';
      };
    nih.xdg.mime = {
      archives = "xarchiver.desktop";
      audio = "mpv.desktop";
      documents = "org.pwmt.zathura.desktop";
      images = "org.gnome.Loupe.desktop";
      torrents = "transmission-gtk.desktop";
      videos = "mpv.desktop";
    };
  };
}
