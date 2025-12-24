{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgWayland = cfg.wayland;
  package = pkgs.kickoff;
in
{
  options.nih.wayland.kickoff = {
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.enable) {
    environment.systemPackages = [ package ];
    nih.wayland.kickoff.executable = "${package}/bin/kickoff";
    nih.user.home.file =
      let
        font = cfgStyle.fonts.sansSerif;
        colors = cfgStyle.palette.colors;
        accentColor = lib.getAttr cfgStyle.palette.accent colors;
      in
      {
        ".config/kickoff/config.toml".source = (
          (pkgs.formats.toml { }).generate "kickoff.toml" {
            prompt = "";
            padding = 100;
            fonts = [ font.family ];
            font_size = font.defaultSize + 2;
            history = {
              decrease_interval = 48;
            };
            colors = {
              background = colors.base;
              prompt = accentColor;
              text = colors.text;
              text_query = colors.text;
              text_selected = accentColor;
            };
            keybindings = {
              paste = [ "ctrl+v" ];
              execute = [
                "KP_Enter"
                "Return"
              ];
              delete = [
                "KP_Delete"
                "Delete"
                "BackSpace"
              ];
              delete_word = [ "ctrl+w" ];
              complete = [ "Tab" ];
              nav_up = [ "Up" ];
              nav_down = [ "Down" ];
              exit = [ "Escape" ];
            };
          }
        );
      };
  };
}
