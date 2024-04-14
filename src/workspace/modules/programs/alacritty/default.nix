{ config, ... }:
{
  home-manager.users.${config.workspace.user.name}.programs.alacritty = {
    enable = true;
    settings = {
      colors = (import ./colors.nix { palette = config.workspace.theme.palette; });
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
      font =
        let
          fontMonospace = config.workspace.theme.font.monospace;
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
}
