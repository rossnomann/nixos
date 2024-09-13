{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgBluetooth = cfg.bluetooth;
in
{
  config = lib.mkIf (cfg.enable && cfgBluetooth.enable) {
    environment.systemPackages = [ pkgs.overskride ];
    nih.x11.wm.windowRules = [
      {
        windowClass = "overskride";
        spawnOnTag = "secondary";
      }
    ];
  };
}
