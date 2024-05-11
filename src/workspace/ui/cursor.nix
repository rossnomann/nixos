{ config, ... }:
let
  cursorTheme = config.workspace.ui.cursorTheme;
in
{
  home-manager.users.${config.workspace.user.name} = {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = false;
      name = cursorTheme.name;
      package = cursorTheme.package;
      size = cursorTheme.size;
    };
  };
}
