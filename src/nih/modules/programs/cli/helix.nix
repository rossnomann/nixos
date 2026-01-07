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
  package = pkgs.helix;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.user.home.file =
      let
        palette = cfgStyle.palette;
      in
      {
        ".config/helix/themes/catppuccin-${palette.variant}.toml".source =
          "${cfgSources.catppuccin-helix}/themes/default/catppuccin_${palette.variant}.toml";
        ".config/helix/config.toml".text = ''
          theme = "catppuccin_${palette.variant}"
          [editor]
          cursorline = true
          gutters = [ "line-numbers", "spacer", "diagnostics", "spacer", "diff", "spacer" ]
          trim-final-newlines = true
          trim-trailing-whitespace = true
          true-color = true
          [editor.cursor-shape]
          normal = "block"
          insert = "bar"
          select = "underline"
          [editor.file-picker]
          hidden = false
          [editor.indent-guides]
          render = true
          [editor.statusline]
          left = [ "version-control", "mode", "file-type", "read-only-indicator", "file-modification-indicator", "file-name" ]
          center = [ "selections", "register", "diagnostics" ]
          right = [ "position", "total-line-numbers", "file-indent-style", "file-encoding", "file-line-ending" ]
          mode.normal = "N"
          mode.insert = "I"
          mode.select = "S"
          [editor.whitespace.render]
          tab = "all"
        '';
      };
    nih.xdg.mime.text = "Helix.desktop";
  };
}
