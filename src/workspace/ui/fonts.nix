{ config, ... }:
let
  font = config.workspace.ui.font;
in
{
  fonts = {
    packages = font.packages;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ font.monospace.family ];
        sansSerif = [ font.sansSerif.family ];
        serif = [ font.serif.family ];
      };
    };
  };
}
