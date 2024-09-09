{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sublime4
      pkgs.sublime-merge
    ];
    nih = {
      # Contains only simple packages without deps, e.g. preferences, syntax highlighting, color schemes, etc...
      user.home.file = {
        # TODO: write a nix package and use npins
        ".config/sublime-text/Installed Packages/FileIconsMono.sublime-package".source = pkgs.fetchurl {
          url = "https://github.com/braver/FileIcons/archive/refs/tags/mono-2.0.4.zip";
          hash = "sha256-9faQarel+9aT8hih+jkHpUAsm6w76HE/ZajBfhIi32Q=";
        };

        ".config/sublime-text/Packages/Dockerfile".source = npins.sublime-text-docker;
        ".config/sublime-text/Packages/GitGutter".source = npins.sublime-text-git-gutter;
        ".config/sublime-text/Packages/User/GitGutter.sublime-settings".text = ''
          {
            "show_line_annotation": false
          }
        '';
        ".config/sublime-text/Packages/Jinja2".source = npins.sublime-text-jinja;
        ".config/sublime-text/Packages/Nix".source = npins.sublime-text-nix;
        ".config/sublime-text/Packages/Nushell".source = npins.sublime-text-nushell;
        ".config/sublime-text/Packages/TOML".source = npins.sublime-text-toml;
        ".config/sublime-text/Packages/Catppuccin/catppuccin.sublime-color-scheme".source =
          let
            themeName = "Catppuccin ${lib.nih.strings.capitalize cfgPalette.variant}.sublime-color-scheme";
          in
          "${npins.catppuccin-sublime-text}/build/${themeName}";
        ".config/sublime-text/Packages/Catppuccin/Preferences.sublime-settings".text =
          let
            font = cfgGui.style.fonts.monospace;
          in
          ''
            {
              "font_face": "${font.family}",
              "font_size": ${builtins.toString font.defaultSize},
              "color_scheme": "catppuccin.sublime-color-scheme",
              "theme": "Adaptive.sublime-theme",
            }
          '';
        ".config/sublime-text/Packages/NixOS/Preferences.sublime-settings".text = ''
          {
            "always_show_minimap_viewport": true,
            "caret_extra_bottom": 0,
            "caret_extra_top": 0,
            "caret_extra_width": 1,
            "caret_style": "blink",
            "close_windows_when_empty": false,
            "default_line_ending": "unix",
            "draw_minimap_border": true,
            "drag_text": false,
            "draw_white_space": "all",
            "ensure_newline_at_eof_on_save": true,
            "fade_fold_buttons": false,
            "fallback_encoding": "Cyrillic (Windows-1251)",
            "file_tab_style": "square",
            "folder_exclude_patterns": [".git"],
            "file_exclude_patterns": ["*.pyc"],
            "hardware_acceleration": "opengl",
            "hide_new_tab_button": true,
            "hide_tab_scrolling_buttons": true,
            "highlight_line": true,
            "higlight_modified_tabs": true,
            "line_padding_bottom": 1,
            "line_padding_top": 2,
            "preview_on_click": false,
            "rulers": [100, 120],
            "save_on_focus_lost": true,
            "shift_tab_unindent": true,
            "show_encoding": true,
            "show_line_column": "compact",
            "show_line_endings": true,
            "show_tab_close_buttons": false,
            "sublime_merge_path": "/run/current-system/sw/bin/sublime_merge",
            "translate_tabs_to_spaces": true,
            "trim_trailing_white_space_on_save": "all",
            "update_system_recent_files": false,
            "word_wrap": false,
          }
        '';
      };
      xdg.mime.text = "sublime_text.desktop";
    };
    nixpkgs.config.permittedInsecurePackages = [
      # https://github.com/sublimehq/sublime_text/issues/5984
      "openssl-1.1.1w"
    ];
  };
}
