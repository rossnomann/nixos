{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  package = pkgs.alacritty;
  executable = "${package}/bin/alacritty";
in
{
  options.nih.programs.terminal = {
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
    executable = lib.mkOption {
      type = lib.types.str;
      default = executable;
    };
    runCommand = lib.mkOption {
      type = lib.types.str;
      default = "${executable} --command";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.terminal.package ];
    nih = {
      user.home.file = {
        ".config/alacritty/alacritty.toml".text =
          let
            fontMonospace = cfgStyle.fonts.monospace;
            themePath = "${npins.catppuccin-alacritty}/catppuccin-${cfgPalette.variant}.toml";
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
      x11.wm.windowRules = [
        {
          windowClass = "Alacritty";
          spawnOnTag = "alacritty";
        }
      ];
    };
  };
}
