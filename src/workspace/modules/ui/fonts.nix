{ config, ... }:
let
  font = config.workspace.theme.font;
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
