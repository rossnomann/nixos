{ config, ... }:
let
  dpi = config.workspace.ui.dpi;
in
{
  services.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "dpi" = ''
          xrandr --dpi ${builtins.toString dpi}
          leftwm command SoftReload
        '';
      };
    };
    ignoreLid = true;
    profiles = {
      default = {
        fingerprint = {
          "eDP1" = "00ffffffffffff0009e5550800000000331c0104a51f117802ff35a756509f270e505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e36350a0086";
        };
        config = {
          "eDP1" = {
            crtc = 0;
            inherit dpi;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
        };
      };
    };
  };
}
