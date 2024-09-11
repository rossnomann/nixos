{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUi = cfg.ui;
in
{
  config = lib.mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      hooks.postswitch."dpi" =
        let
          xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
          wmReload = cfgUi.x11.wm.commands.reload;
        in
        ''
          ${xrandr} --dpi ${builtins.toString cfgUi.dpi}
          ${wmReload}
        '';
      ignoreLid = true;
      profiles = cfgUi.x11.autorandr.profiles;
    };
  };
}
