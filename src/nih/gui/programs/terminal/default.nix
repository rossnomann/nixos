{ config, lib, ... }:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgPalette = cfg.palette;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${cfgUser.name}.programs.alacritty = {
      enable = true;
      settings = {
        colors = (import ./colors.nix { palette = cfgPalette.current; });
        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };
        };
        font =
          let
            fontMonospace = cfgGui.style.fonts.monospace;
          in
          {
            normal = {
              family = fontMonospace.family;
            };
            size = fontMonospace.defaultSize;
          };
        scrolling = {
          history = 100000;
        };
        window = {
          decorations = "None";
          padding = {
            x = 20;
            y = 10;
          };
        };
      };
    };
  };
}
