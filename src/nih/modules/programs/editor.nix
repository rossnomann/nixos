{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sublime4
      pkgs.sublime-merge
    ];
    nih.user.home.file = {
      ".config/sublime-text/Packages/Dockerfile".source = npins.sublime-text-docker;
      ".config/sublime-text/Packages/FileIconsMono".source = npins.sublime-text-file-icons-mono;
      ".config/sublime-text/Packages/GitGutter".source = npins.sublime-text-git-gutter;
      ".config/sublime-text/Packages/Jinja2".source = npins.sublime-text-jinja;
      ".config/sublime-text/Packages/LSP".source = npins.sublime-text-lsp;
      ".config/sublime-text/Packages/MarkdownPreview".source = npins.sublime-text-markdown-preview;
      ".config/sublime-text/Packages/Nix".source = npins.sublime-text-nix;
      ".config/sublime-text/Packages/Nushell".source = npins.sublime-text-nushell;
      ".config/sublime-text/Packages/ProjectManager".source = npins.sublime-text-project-manager;
      ".config/sublime-text/Packages/RON".source = npins.sublime-text-ron;
      ".config/sublime-text/Packages/RustEnhanced".source = npins.sublime-text-rust-enhanced;
      ".config/sublime-text/Packages/TOML".source = npins.sublime-text-toml;
      ".config/sublime-text/Packages/Catppuccin/catppuccin.sublime-color-scheme".source =
        let
          variant = lib.nih.strings.capitalize cfgStyle.palette.variant;
          themeName = "Catppuccin ${variant}.sublime-color-scheme";
        in
        "${npins.catppuccin-sublime-text}/build/${themeName}";
      ".config/sublime-text/Packages/Catppuccin/Preferences.sublime-settings".text =
        let
          font = cfgStyle.fonts.monospace;
        in
        builtins.toJSON {
          font_face = "${font.family}";
          font_size = font.defaultSize;
          color_scheme = "catppuccin.sublime-color-scheme";
          theme = "Adaptive.sublime-theme";
        };
      ".config/sublime-text/Packages/NixOS/GitGutter.sublime-settings".text = builtins.toJSON {
        show_line_annotation = false;
      };
      ".config/sublime-text/Packages/NixOS/Preferences.sublime-settings".text = builtins.toJSON {
        always_show_minimap_viewport = true;
        caret_extra_bottom = 0;
        caret_extra_top = 0;
        caret_extra_width = 1;
        caret_style = "blink";
        close_windows_when_empty = false;
        default_line_ending = "unix";
        draw_minimap_border = true;
        drag_text = false;
        draw_white_space = "all";
        ensure_newline_at_eof_on_save = true;
        fade_fold_buttons = false;
        fallback_encoding = "Cyrillic (Windows-1251)";
        file_tab_style = "square";
        folder_exclude_patterns = [ ".git" ];
        file_exclude_patterns = [ "*.pyc" ];
        hardware_acceleration = "opengl";
        hide_new_tab_button = true;
        hide_tab_scrolling_buttons = true;
        highlight_line = true;
        higlight_modified_tabs = true;
        line_padding_bottom = 1;
        line_padding_top = 2;
        preview_on_click = false;
        rulers = [
          100
          120
        ];
        save_on_focus_lost = true;
        shift_tab_unindent = true;
        show_encoding = true;
        show_line_column = "compact";
        show_line_endings = true;
        show_tab_close_buttons = false;
        sublime_merge_path = "/run/current-system/sw/bin/sublime_merge";
        translate_tabs_to_spaces = true;
        trim_trailing_white_space_on_save = "all";
        update_system_recent_files = false;
        word_wrap = false;
      };
    };
    nih.windowRules = [
      {
        x11Class = "sublime_text";
        waylandAppId = "sublime_text";
        useWorkspace = "main";
      }
      {
        x11Class = "sublime_merge";
        waylandAppId = "sublime_merge";
        useWorkspace = "main";
      }
    ];
    nih.xdg.mime.text = "sublime_text.desktop";
    nixpkgs.config.permittedInsecurePackages = [
      # https://github.com/sublimehq/sublime_text/issues/5984
      "openssl-1.1.1w"
    ];
  };
}
