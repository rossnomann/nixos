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
    nih.windowRules = [
      {
        x11Class = "overskride";
        waylandAppId = "io.github.kaii_lb.Overskride";
        useWorkspace = "secondary";
      }
    ];
  };
}
