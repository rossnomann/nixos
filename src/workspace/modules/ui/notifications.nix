{ config, pkgs, ... }:
let
  ui = config.workspace.ui;
  font = ui.font.sansSerif;
  iconTheme = ui.iconTheme;
  palette = ui.palette;
in
{
  environment.systemPackages = [ pkgs.libnotify ];
  home-manager.users.${config.workspace.user.name} = {
    services = {
      dunst = {
        enable = true;
        iconTheme = {
          name = iconTheme.name;
          package = iconTheme.package;
        };
        settings =
          let
          in
          {
            global = {
              background = palette.base;
              font = "${font.family} ${builtins.toString font.defaultSize}";
              follow = "keyboard";
              foreground = palette.text;
              frame_color = palette.green;
              frame_width = 1;
              gap_size = 12;
              offset = "24x24";
              origin = "top-right";
            };
            urgency_low = {
              frame_color = palette.blue;
            };
            urgency_critical = {
              frame_color = palette.red;
            };
          };
      };
    };
  };
}
