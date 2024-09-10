{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
in
{
  config = lib.mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      hooks.postswitch."dpi" =
        let
          xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
          leftwm = "${pkgs.leftwm}/bin/leftwm"; # TODO: package from config
        in
        ''
          ${xrandr} --dpi ${builtins.toString cfgGui.dpi}
          ${leftwm} command SoftReload
        '';
      ignoreLid = true;
      profiles = cfgGui.x11.autorandr.profiles;
    };
  };
}
