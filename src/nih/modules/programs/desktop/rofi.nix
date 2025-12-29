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
  package = pkgs.rofi;
  executable = "${package}/bin/rofi";
in
{
  options.nih.programs.desktop.rofi = {
    cmdShow = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.programs.desktop.rofi.cmdShow = [
      executable
      "-show"
      "combi"
    ];
    nih.user.home.file = {
      ".config/rofi/config.rasi".text = ''
        @import "palette"
        @import "theme"

        configuration {
          click-to-exit: true;
          combi-hide-mode-prefix: true;
          display-combi: ">>>";
          drun-show-actions: true;
          fixed-num-lines: true;
          font: "mono ${builtins.toString cfgStyle.fonts.monospace.defaultSize}";
          location: 0;
          modes: "combi,window,drun";
          show-icons: false;
          steal-focus: true;
        }
      '';
      ".config/rofi/theme.rasi".source = "${cfgSources.catppuccin-rofi}/catppuccin-default.rasi";
      ".config/rofi/palette.rasi".source =
        "${cfgSources.catppuccin-rofi}/themes/catppuccin-${cfgStyle.palette.variant}.rasi";
    };
  };
}
