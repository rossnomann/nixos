{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgWayland = cfg.wayland;
in
{
  options.nih.wayland.programs.rot8 = {
    enable = lib.mkEnableOption "screen rotation";
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
    device = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    touchscreen = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    execStart = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf (cfg.enable && cfgWayland.programs.rot8.enable) {
    environment.systemPackages = [ cfgWayland.programs.rot8.package ];
    nih.wayland.compositor.spawnAtStartup = [
      (lib.strings.concatStringsSep " " (
        lib.lists.remove null [
          ''"${cfgWayland.programs.rot8.executable}"''
          (lib.mapNullable (x: ''"-d" "${x}"'') cfgWayland.programs.rot8.device)
          (lib.mapNullable (x: ''"--touchscreen" "'${x}'"'') cfgWayland.programs.rot8.touchscreen)
        ]
      ))
    ];
    nih.wayland.programs.rot8.executable = "${cfgWayland.programs.rot8.package}/bin/rot8";
    nih.wayland.programs.rot8.package = pkgs.rot8;
  };
}
