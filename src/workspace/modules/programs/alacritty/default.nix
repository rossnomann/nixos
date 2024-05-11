{ config, ... }:
let
  ui = config.workspace.ui;
  font = ui.font.monospace;
  palette = ui.palette;
in
{
  home-manager.users.${config.workspace.user.name}.programs.alacritty = {
    enable = true;
    settings = {
      colors = (import ./colors.nix { inherit palette; });
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
      font = {
        normal = {
          family = font.family;
        };
        size = font.defaultSize;
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
}
