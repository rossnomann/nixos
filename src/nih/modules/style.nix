{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cursors = {
    name = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}-cursors";
    size = cfgStyle.cursors.size;
  };
  gtk = {
    decorationLayout = ":";
    fontName = "${cfgStyle.fonts.sansSerif.family} ${builtins.toString cfgStyle.fonts.sansSerif.defaultSize}";
    themeName = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}-compact+rimless";
  };
  icons = {
    name = cfgStyle.icons.name;
  };
  kvantum = {
    themeName = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}";
  };
in
{
  options.nih.style = {
    cursors = {
      name = lib.mkOption { type = lib.types.str; };
      size = lib.mkOption { type = lib.types.int; };
    };

    fonts = {
      packages = lib.mkOption { type = lib.types.listOf lib.types.package; };
      monospace = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
      sansSerif = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
      serif = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
    };

    icons = {
      name = lib.mkOption { type = lib.types.str; };
      package = lib.mkOption { type = lib.types.package; };
    };

    palette = {
      variant = lib.mkOption { type = lib.types.str; };
      accent = lib.mkOption { type = lib.types.str; };
      colors = lib.mkOption {
        type = lib.types.attrs;
        default = lib.getAttr cfgStyle.palette.variant lib.nih.catppuccin.colors;
      };
    };

    packages = {
      cursors = lib.mkOption { type = lib.types.package; };
      gtk = lib.mkOption { type = lib.types.package; };
      index = lib.mkOption { type = lib.types.package; };
      qt = lib.mkOption { type = lib.types.package; };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/share/Kvantum"
      "/share/gsettings-schemas"
    ];
    environment.profileRelativeSessionVariables =
      let
        qtVersions = [
          pkgs.qt5
          pkgs.qt6
        ];
      in
      {
        QT_PLUGIN_PATH = map (qt: "/${qt.qtbase.qtPluginPrefix}") qtVersions;
        QML2_IMPORT_PATH = map (qt: "/${qt.qtbase.qtQmlPrefix}") qtVersions;
      };
    environment.sessionVariables = {
      GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc";
      XCURSOR_SIZE = cursors.size;
      XCURSOR_THEME = cursors.name;
      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}"
        "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
      ];
    };
    environment.systemPackages = [
      cfgStyle.icons.package
      cfgStyle.packages.cursors
      cfgStyle.packages.gtk
      cfgStyle.packages.index
      cfgStyle.packages.qt
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.qt6Packages.qtstyleplugin-kvantum
    ];
    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_STYLE_OVERRIDE = "kvantum";
    };

    fonts.packages = cfgStyle.fonts.packages;
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ cfgStyle.fonts.monospace.family ];
        sansSerif = [ cfgStyle.fonts.sansSerif.family ];
        serif = [ cfgStyle.fonts.serif.family ];
      };
    };

    nih.style.cursors.name = cursors.name;
    nih.style.packages.cursors = pkgs.nih.catppuccin.cursors {
      accent = cfgStyle.palette.accent;
      variant = cfgStyle.palette.variant;
    };
    nih.style.packages.gtk = pkgs.nih.catppuccin.gtk {
      accent = cfgStyle.palette.accent;
      variant = cfgStyle.palette.variant;
    };
    nih.style.packages.index = pkgs.nih.cursor-theme-default cfgStyle.cursors.name;
    nih.style.packages.qt = pkgs.nih.catppuccin.kvantum;
    nih.user.home.file = {
      ".config/Kvantum/kvantum.kvconfig".text = ''
        theme=${kvantum.themeName}
      '';
      ".config/gtk-2.0/gtkrc".text = lib.nih.gen.gtk.mkGtk2Settings {
        cursorThemeName = cursors.name;
        cursorThemeSize = cursors.size;
        fontName = gtk.fontName;
        iconThemeName = icons.name;
        themeName = gtk.themeName;
      };
      ".config/gtk-3.0/gtk.css".text = ''
        * {
          border-radius: 0 0 0 0;
          box-shadow: none;
        }
      '';
      ".config/gtk-3.0/settings.ini".text = lib.nih.gen.gtk.mkGtk3Settings {
        cursorThemeName = cursors.name;
        cursorThemeSize = cursors.size;
        decorationLayout = gtk.decorationLayout;
        fontName = gtk.fontName;
        iconThemeName = icons.name;
        themeName = gtk.themeName;
      };
      ".config/gtk-4.0/gtk.css".text = ''
        /**
         * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
         * It does however respect user CSS, so import the theme from here.
        **/
        @import url("file://${cfgStyle.packages.gtk}/share/themes/${gtk.themeName}/gtk-4.0/gtk.css");
        * {
          border-radius: 0 0 0 0;
          box-shadow: none;
        }
      '';
      ".config/gtk-4.0/settings.ini".text = lib.nih.gen.gtk.mkGtk4Settings {
        cursorThemeName = cursors.name;
        cursorThemeSize = cursors.size;
        decorationLayout = gtk.decorationLayout;
        fontName = gtk.fontName;
        iconThemeName = icons.name;
        themeName = gtk.themeName;
      };
      ".icons/default/index.theme".source = "${cfgStyle.packages.index}/share/icons/default/index.theme";
      ".icons/${cursors.name}".source = "${cfgStyle.packages.cursors}/share/icons/${cursors.name}";
      ".local/share/icons/default/index.theme".source = "${cfgStyle.packages.index}/share/icons/default/index.theme";
      ".local/share/icons/${cursors.name}".source = "${cfgStyle.packages.cursors}/share/icons/${cursors.name}";
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              cursor-size = lib.gvariant.mkUint32 cursors.size;
              cursor-theme = cursors.name;
              font-name = gtk.fontName;
              gtk-theme = gtk.themeName;
              icon-theme = icons.name;
            };
          };
        }
      ];
    };
    xdg.portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
