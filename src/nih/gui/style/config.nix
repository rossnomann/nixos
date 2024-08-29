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
  cursors = {
    name = "catppuccin-${cfgPalette.variant}-${cfgPalette.accent}-cursors";
    size = cfgGui.style.cursors.size;
  };
  gtk = {
    decorationLayout = ":";
    fontName = "${cfgGui.style.fonts.sansSerif.family} ${builtins.toString cfgGui.style.fonts.sansSerif.defaultSize}";
    themeName = "catppuccin-${cfgPalette.variant}-${cfgPalette.accent}-compact+rimless";
  };
  icons = {
    name = cfgGui.style.icons.name;
  };
  kvantum = {
    themeName = "catppuccin-${cfgPalette.variant}-${cfgPalette.accent}";
  };
in
{
  config = lib.mkIf cfg.enable {
    nih = {
      gui.style.cursors.name = cursors.name;
      user.home.file = {
        ".config/Kvantum/kvantum.kvconfig".source.text = ''
          theme=${kvantum.themeName}
        '';
        ".config/gtk-2.0/gtkrc".source.text = ''
          gtk-cursor-theme-name = "${cursors.name}"
          gtk-cursor-theme-size = ${builtins.toString cursors.size}
          gtk-font-name = "${gtk.fontName}"
          gtk-icon-theme-name = "${icons.name}"
          gtk-theme-name = "${gtk.themeName}"
        '';
        ".config/gtk-3.0/gtk.css".source.text = ''
          * {
            border-radius: 0 0 0 0;
            box-shadow: none;
          }
        '';
        ".config/gtk-3.0/settings.ini".source.text = ''
          [Settings]
          gtk-cursor-theme-name=${cursors.name}
          gtk-cursor-theme-size=${builtins.toString cursors.size}
          gtk-decoration-layout=${gtk.decorationLayout}
          gtk-font-name=${gtk.fontName}
          gtk-icon-theme-name=${icons.name}
          gtk-theme-name=${gtk.themeName}
        '';
        ".config/gtk-4.0/gtk.css".source.text = ''
          /**
           * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
           * It does however respect user CSS, so import the theme from here.
          **/
          @import url("file://${cfgGui.style.packages.gtk}/share/themes/${gtk.themeName}/gtk-4.0/gtk.css");
          * {
            border-radius: 0 0 0 0;
            box-shadow: none;
          }
        '';
        ".config/gtk-4.0/settings.ini".source.text = ''
          [Settings]
          gtk-cursor-theme-name=${cursors.name}
          gtk-cursor-theme-size=${builtins.toString cursors.size}
          gtk-decoration-layout=${gtk.decorationLayout}
          gtk-font-name=${gtk.fontName}
          gtk-icon-theme-name=${icons.name}
          gtk-theme-name=${gtk.themeName}
        '';
        ".icons/default/index.theme".source.path = "${cfgGui.style.packages.index}/share/icons/default/index.theme";
        ".icons/${cursors.name}".source.path = "${cfgGui.style.packages.cursors}/share/icons/${cursors.name}";
        ".local/share/backgrounds/default.jpg".source.path = ./resources/backgrounds/default.jpg;
        ".local/share/backgrounds/default-empty.jpg".source.path = ./resources/backgrounds/default-empty.jpg;
        ".local/share/icons/default/index.theme".source.path = "${cfgGui.style.packages.index}/share/icons/default/index.theme";
        ".local/share/icons/${cursors.name}".source.path = "${cfgGui.style.packages.cursors}/share/icons/${cursors.name}";
      };
    };
    fonts = {
      packages = cfgGui.style.fonts.packages;
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ cfgGui.style.fonts.monospace.family ];
          sansSerif = [ cfgGui.style.fonts.sansSerif.family ];
          serif = [ cfgGui.style.fonts.serif.family ];
        };
      };
    };
    environment = {
      pathsToLink = [
        "/share/Kvantum"
        "/share/gsettings-schemas"
      ];
      profileRelativeSessionVariables =
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
      sessionVariables = {
        GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc";
        XCURSOR_SIZE = cursors.size;
        XCURSOR_THEME = cursors.name;
        XDG_DATA_DIRS = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}"
          "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
        ];
      };
      systemPackages = [
        cfgGui.style.icons.package
        cfgGui.style.packages.cursors
        cfgGui.style.packages.gtk
        cfgGui.style.packages.index
        cfgGui.style.packages.qt
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
      ];
      variables = {
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_STYLE_OVERRIDE = "kvantum";
      };
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
