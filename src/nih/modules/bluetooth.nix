{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
  cfgBluetooth = cfg.bluetooth;
in
{
  options.nih.bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
  };
  config = lib.mkIf (cfg.enable && cfgBluetooth.enable) {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Experimental = true;
          KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e";
        };
      };
    };
  };
}
