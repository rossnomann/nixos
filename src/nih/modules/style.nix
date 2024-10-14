{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  options.nih.style = {
    cursors = {
      name = lib.mkOption { type = lib.types.str; };
      size = lib.mkOption { type = lib.types.int; };
      indexPackage = lib.mkOption { type = lib.types.package; };
      themePackage = lib.mkOption { type = lib.types.package; };
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

    gtk = {
      decorationLayout = lib.mkOption { type = lib.types.str; };
      fontName = lib.mkOption { type = lib.types.str; };
      theme = {
        name = lib.mkOption { type = lib.types.str; };
        package = lib.mkOption { type = lib.types.package; };
      };
    };

    qt = {
      kvantum.theme = {
        name = lib.mkOption { type = lib.types.str; };
        package = lib.mkOption { type = lib.types.package; };
      };
    };

    wallpaper = lib.mkOption { type = lib.types.path; };
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
      XCURSOR_SIZE = cfgStyle.cursors.size;
      XCURSOR_THEME = cfgStyle.cursors.name;
      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}"
        "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
      ];
    };
    environment.systemPackages = [
      cfgStyle.cursors.themePackage
      cfgStyle.cursors.indexPackage
      cfgStyle.gtk.theme.package
      cfgStyle.icons.package
      cfgStyle.qt.kvantum.theme.package
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.qt6Packages.qtstyleplugin-kvantum
      pkgs.libsForQt5.qt5ct
      pkgs.qt6Packages.qt6ct
    ];
    environment.variables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
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

    nih.style.cursors.name = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}-cursors";
    nih.style.cursors.indexPackage = pkgs.nih.cursor-theme-default cfgStyle.cursors.name;
    nih.style.cursors.themePackage = pkgs.nih.catppuccin.cursors {
      accent = cfgStyle.palette.accent;
      variant = cfgStyle.palette.variant;
    };
    nih.style.gtk.decorationLayout = ":";
    nih.style.gtk.fontName = "${cfgStyle.fonts.sansSerif.family} ${builtins.toString cfgStyle.fonts.sansSerif.defaultSize}";
    nih.style.gtk.theme.name = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}-compact+rimless";
    nih.style.gtk.theme.package = pkgs.nih.catppuccin.gtk {
      accent = cfgStyle.palette.accent;
      variant = cfgStyle.palette.variant;
    };
    nih.style.qt.kvantum.theme.name = "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}";
    nih.style.qt.kvantum.theme.package = pkgs.nih.catppuccin.kvantum {
      src = cfgSources.catppuccin-kvantum;
    };
    nih.style.wallpaper = "${pkgs.nih.wallpapers}/share/wallpapers/nih/default.jpg";

    nih.user.home.file = {
      ".config/Kvantum/kvantum.kvconfig".text = ''
        theme=${cfgStyle.qt.kvantum.theme.name}
      '';
      ".config/gtk-2.0/gtkrc".text = lib.nih.gen.gtk.mkGtk2Settings {
        cursorThemeName = cfgStyle.cursors.name;
        cursorThemeSize = cfgStyle.cursors.size;
        fontName = cfgStyle.gtk.fontName;
        iconThemeName = cfgStyle.icons.name;
        themeName = cfgStyle.gtk.theme.name;
      };
      ".config/gtk-3.0/gtk.css".text = ''
        * {
          border-radius: 0 0 0 0;
          box-shadow: none;
        }
      '';
      ".config/gtk-3.0/settings.ini".text = lib.nih.gen.gtk.mkGtk3Settings {
        cursorThemeName = cfgStyle.cursors.name;
        cursorThemeSize = cfgStyle.cursors.size;
        decorationLayout = cfgStyle.gtk.decorationLayout;
        fontName = cfgStyle.gtk.fontName;
        iconThemeName = cfgStyle.icons.name;
        themeName = cfgStyle.gtk.theme.name;
      };
      ".config/gtk-4.0/gtk.css".text = ''
        /**
         * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
         * It does however respect user CSS, so import the theme from here.
        **/
        @import url("file://${cfgStyle.gtk.theme.package}/share/themes/${cfgStyle.gtk.theme.name}/gtk-4.0/gtk.css");
        * {
          border-radius: 0 0 0 0;
          box-shadow: none;
        }
      '';
      ".config/gtk-4.0/settings.ini".text = lib.nih.gen.gtk.mkGtk4Settings {
        cursorThemeName = cfgStyle.cursors.name;
        cursorThemeSize = cfgStyle.cursors.size;
        decorationLayout = cfgStyle.gtk.decorationLayout;
        fontName = cfgStyle.gtk.fontName;
        iconThemeName = cfgStyle.icons.name;
        themeName = cfgStyle.gtk.theme.name;
      };
      ".config/qt5ct/colors/catppuccin.conf".text = lib.nih.gen.qtct.mkColors cfgStyle.palette.colors;
      ".config/qt6ct/colors/catppuccin.conf".text = lib.nih.gen.qtct.mkColors cfgStyle.palette.colors;
      ".icons/default/index.theme".source = "${cfgStyle.cursors.indexPackage}/share/icons/default/index.theme";
      ".icons/${cfgStyle.cursors.name}".source = "${cfgStyle.cursors.themePackage}/share/icons/${cfgStyle.cursors.name}";
      ".local/share/icons/default/index.theme".source = "${cfgStyle.cursors.indexPackage}/share/icons/default/index.theme";
      ".local/share/icons/${cfgStyle.cursors.name}".source = "${cfgStyle.cursors.themePackage}/share/icons/${cfgStyle.cursors.name}";
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              cursor-size = lib.gvariant.mkUint32 cfgStyle.cursors.size;
              cursor-theme = cfgStyle.cursors.name;
              font-name = cfgStyle.gtk.fontName;
              gtk-theme = cfgStyle.gtk.theme.name;
              icon-theme = cfgStyle.icons.name;
            };
          };
        }
      ];
    };
  };
}
