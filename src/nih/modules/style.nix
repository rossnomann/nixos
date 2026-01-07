{
  config,
  lib,
  lightly,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
  cfgUser = cfg.user;
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
      accentColor = lib.mkOption { type = lib.types.str; };
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

    wallpaper = lib.mkOption { type = lib.types.path; };
  };
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
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
      pkgs.libsForQt5.qt5ct
      pkgs.qt6Packages.qt6ct
      lightly.packages.${pkgs.stdenv.hostPlatform.system}.darkly-qt5
      lightly.packages.${pkgs.stdenv.hostPlatform.system}.darkly-qt6
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
    nih.style.cursors.indexPackage =
      let
        inherits = cfgStyle.cursors.name;
      in
      pkgs.writeTextFile {
        name = "index.theme";
        destination = "/share/icons/default/index.theme";
        # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
        text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${inherits}
        '';
      };
    nih.style.cursors.themePackage =
      let
        name = "${cfgStyle.palette.variant}${lib.strings.toSentenceCase cfgStyle.palette.accent}";
      in
      lib.getAttr name pkgs.catppuccin-cursors;
    nih.style.gtk.decorationLayout = ":";
    nih.style.gtk.fontName = "${cfgStyle.fonts.sansSerif.family} ${toString cfgStyle.fonts.sansSerif.defaultSize}";
    nih.style.gtk.theme.name =
      "catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}-compact+rimless";
    nih.style.gtk.theme.package = pkgs.catppuccin-gtk.override {
      accents = [ cfgStyle.palette.accent ];
      size = "compact";
      tweaks = [ "rimless" ];
      variant = cfgStyle.palette.variant;
    };
    nih.style.palette.accentColor = lib.getAttr cfgStyle.palette.accent cfgStyle.palette.colors;
    nih.style.wallpaper = "${pkgs.nih.wallpapers}/share/wallpapers/nih/default.jpg";

    nih.user.home.file = {
      ".config/darklyrc".text = ''
        [Common]
        ButtonSize=-2
        CornerRadius=1
        OutlineCloseButton=false
        ShadowSize=ShadowNone

        [Style]
        AnimationsEnabled=false
        RoundedRubberBandFrame=false
        TabsHeight=-20
        WidgetDrawShadow=false

        [Windeco]
        AnimationsEnabled=false
        ButtonSize=ButtonSmall
        DrawBackgroundGradient=false
      '';
      ".config/gtk-2.0/gtkrc".text = ''
        gtk-cursor-theme-name = "${cfgStyle.cursors.name}"
        gtk-cursor-theme-size = ${toString cfgStyle.cursors.size}
        gtk-font-name = "${cfgStyle.gtk.fontName}"
        gtk-icon-theme-name = "${cfgStyle.icons.name}"
        gtk-theme-name = "${cfgStyle.gtk.theme.name}"
      '';
      ".config/gtk-3.0/gtk.css".text = ''
        * {
          border-radius: 0 0 0 0;
          box-shadow: none;
        }
      '';
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
          gtk-cursor-theme-name=${cfgStyle.cursors.name}
          gtk-cursor-theme-size=${toString cfgStyle.cursors.size}
          gtk-decoration-layout=${cfgStyle.gtk.decorationLayout}
          gtk-font-name=${cfgStyle.gtk.fontName}
          gtk-icon-theme-name=${cfgStyle.icons.name}
          gtk-theme-name=${cfgStyle.gtk.theme.name}
      '';
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
      ".config/gtk-4.0/settings.ini".text = ''
        [Settings]
          gtk-cursor-theme-name=${cfgStyle.cursors.name}
          gtk-cursor-theme-size=${toString cfgStyle.cursors.size}
          gtk-decoration-layout=${cfgStyle.gtk.decorationLayout}
          gtk-font-name=${cfgStyle.gtk.fontName}
          gtk-icon-theme-name=${cfgStyle.icons.name}
          gtk-theme-name=${cfgStyle.gtk.theme.name}
      '';
      ".config/qt5ct/qt5ct.conf".text = ''
        [Appearance]
        color_scheme_path=${cfgUser.home.root}/.config/qt5ct/colors/catppuccin.conf
        custom_palette=true
        icon_theme=${cfgStyle.icons.name}
        standard_dialogs=xdgdesktopportal
        style=Darkly

        [Fonts]
        fixed="${cfgStyle.fonts.monospace.family},${toString cfgStyle.fonts.monospace.defaultSize},-1,5,50,0,0,0,0,0"
        general="${cfgStyle.fonts.sansSerif.family},${toString cfgStyle.fonts.sansSerif.defaultSize},-1,5,50,0,0,0,0,0"

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=3
        cursor_flash_time=1200
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=@Invalid()
        keyboard_scheme=2
        menus_have_icons=false
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3

        [Troubleshooting]
        force_raster_widgets=1
        ignored_applications=@Invalid()
      '';
      ".config/qt5ct/colors/catppuccin.conf".source =
        "${cfgSources.catppuccin-qtct}/themes/catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}.conf";
      ".config/qt6ct/qt6ct.conf".text = ''
        [Appearance]
        color_scheme_path=${cfgUser.home.root}/.config/qt6ct/colors/catppuccin.conf
        custom_palette=true
        icon_theme=${cfgStyle.icons.name}
        standard_dialogs=xdgdesktopportal
        style=Darkly

        [Fonts]
        fixed="${cfgStyle.fonts.monospace.family},${toString cfgStyle.fonts.monospace.defaultSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
        general="${cfgStyle.fonts.sansSerif.family},${toString cfgStyle.fonts.sansSerif.defaultSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=3
        cursor_flash_time=1200
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=@Invalid()
        keyboard_scheme=2
        menus_have_icons=false
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3

        [Troubleshooting]
        force_raster_widgets=1
        ignored_applications=@Invalid()
      '';
      ".config/qt6ct/colors/catppuccin.conf".source =
        "${cfgSources.catppuccin-qtct}/themes/catppuccin-${cfgStyle.palette.variant}-${cfgStyle.palette.accent}.conf";
      ".icons/default/index.theme".source =
        "${cfgStyle.cursors.indexPackage}/share/icons/default/index.theme";
      ".icons/${cfgStyle.cursors.name}".source =
        "${cfgStyle.cursors.themePackage}/share/icons/${cfgStyle.cursors.name}";
      ".local/share/icons/default/index.theme".source =
        "${cfgStyle.cursors.indexPackage}/share/icons/default/index.theme";
      ".local/share/icons/${cfgStyle.cursors.name}".source =
        "${cfgStyle.cursors.themePackage}/share/icons/${cfgStyle.cursors.name}";
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
