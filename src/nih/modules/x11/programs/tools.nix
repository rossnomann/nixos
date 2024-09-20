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
  config = lib.mkIf (cfg.enable && cfgX11.enable) {
    environment.systemPackages = [
      pkgs.arandr
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xorg.xdpyinfo
      pkgs.xorg.xkill
    ];
  };
}
