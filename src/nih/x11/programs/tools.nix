{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.arandr
      pkgs.wmctrl
      pkgs.xclip
      pkgs.xorg.xdpyinfo
      pkgs.xorg.xkill
    ];
  };
}
