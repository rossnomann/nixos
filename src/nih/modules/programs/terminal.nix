{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
in
{
  options.nih.programs.terminal = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
    runCommand = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.terminal.package ];
    nih.programs.terminal.executable = "${cfgPrograms.terminal.package}/bin/alacritty";
    nih.programs.terminal.package = pkgs.alacritty;
    nih.programs.terminal.runCommand = "${cfgPrograms.terminal.executable} --command";
    nih.user.home.file = {
      ".config/alacritty/alacritty.toml".text =
        let
          fontMonospace = cfgStyle.fonts.monospace;
          themePath = "${npins.catppuccin-alacritty}/catppuccin-${cfgStyle.palette.variant}.toml";
        in
        ''
          import = ["${themePath}"]
          [cursor.style]
          blinking = "Always"
          shape = "Beam"
          [font]
          size = ${builtins.toString fontMonospace.defaultSize}
          [font.normal]
          family = "${fontMonospace.family}"
          [scrolling]
          history = 100000
          [window]
          decorations = "None"
          [window.padding]
          x = 20
          y = 10
        '';
    };
    nih.x11.wm.windowRules = [
      {
        windowClass = "Alacritty";
        spawnOnTag = "alacritty";
      }
    ];
  };
}
