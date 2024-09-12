{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgX11 = cfg.x11;
in
{
  config = lib.mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      hooks.postswitch."dpi" =
        let
          xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
          wmReload = cfgX11.wm.commands.reload;
        in
        ''
          ${xrandr} --dpi ${builtins.toString cfgX11.dpi}
          ${wmReload}
        '';
      ignoreLid = true;
      profiles = cfgX11.autorandr.profiles;
    };
  };
}
