{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.libnotify ];
  home-manager.users.${config.workspace.user.name} = {
    services = {
      dunst = {
        enable = true;
        iconTheme = {
          name = config.workspace.theme.iconTheme.name;
          package = config.workspace.theme.iconTheme.package;
        };
        settings =
          let
            fontSansSerif = config.workspace.theme.font.sansSerif;
            palette = config.workspace.theme.palette;
          in
          {
            global = {
              background = palette.base;
              font = "${fontSansSerif.family} ${builtins.toString fontSansSerif.defaultSize}";
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
