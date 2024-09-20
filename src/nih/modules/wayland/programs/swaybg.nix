{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgWayland = cfg.wayland;
in
{
  options.nih.wayland.programs.swaybg = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.enable) {
    nih.wayland.compositor.spawnAtStartup = [
      ''"${cfgWayland.programs.swaybg.executable}" "-i" "${cfgStyle.wallpaper}"''
    ];
    nih.wayland.programs.swaybg.executable = "${cfgWayland.programs.swaybg.package}/bin/swaybg";
    nih.wayland.programs.swaybg.package = pkgs.swaybg;
  };
}
