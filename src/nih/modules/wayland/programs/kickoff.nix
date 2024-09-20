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
in
{
  options.nih.wayland.programs.kickoff = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.enable) {
    environment.systemPackages = [ cfgWayland.programs.kickoff.package ];
    nih.user.home.file =
      let
        font = cfgStyle.fonts.sansSerif;
        colors = cfgStyle.palette.colors;
        accentColor = lib.getAttr cfgStyle.palette.accent colors;
      in
      {
        ".config/kickoff/config.toml".text = ''
          prompt = ""
          padding = 100
          fonts = ["${font.family}"]
          font_size = ${builtins.toString (font.defaultSize + 2)}
          [history]
          decrease_interval = 48 # interval to decrease the number of launches in hours
          [colors]
          background = '${colors.base}'
          prompt = '${accentColor}'
          text = '${colors.text}'
          text_query = '${colors.text}'
          text_selected = '${accentColor}'
          [keybindings]
          paste = ["ctrl+v"]
          execute = ["KP_Enter", "Return"]
          delete = ["KP_Delete", "Delete", "BackSpace"]
          delete_word = ["ctrl+w"]
          complete = ["Tab"]
          nav_up = ["Up"]
          nav_down = ["Down"]
          exit = ["Escape"]
        '';
      };
    nih.wayland.programs.kickoff.executable = "${cfgWayland.programs.kickoff.package}/bin/kickoff";
    nih.wayland.programs.kickoff.package = pkgs.kickoff;
  };
}
