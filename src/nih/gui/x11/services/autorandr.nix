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
          wmReload = cfgGui.x11.wm.commands.reload;
        in
        ''
          ${xrandr} --dpi ${builtins.toString cfgGui.dpi}
          ${wmReload}
        '';
      ignoreLid = true;
      profiles = cfgGui.x11.autorandr.profiles;
    };
  };
}
