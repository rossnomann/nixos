{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPower = cfg.power;
in
{
  options.nih.power = {
    powertop.enable = lib.mkEnableOption "powertop";
    suspend.enable = lib.mkEnableOption "suspend";
  };
  config = lib.mkIf cfg.enable {
    environment = lib.mkIf cfgPower.powertop.enable { systemPackages = [ pkgs.powertop ]; };
    powerManagement.powertop.enable = cfgPower.powertop.enable;
    services = {
      logind =
        let
          lidSwitch = if cfgPower.suspend.enable then "suspend-then-hibernate" else "ignore";
          lidSwitchExternalPower = if cfgPower.suspend.enable then "suspend" else "ignore";
        in
        {
          inherit lidSwitch;
          inherit lidSwitchExternalPower;
          extraConfig = ''
            IdleAction=ignore
          '';
          killUserProcesses = true;
          lidSwitchDocked = "ignore";

          powerKey = "ignore";
          powerKeyLongPress = "poweroff";
        };
      thermald.enable = true;
      tlp.enable = true;
    };
    systemd.sleep.extraConfig =
      let
        allow = if cfgPower.suspend.enable then "yes" else "no";
      in
      ''
        AllowSuspend=${allow}
        AllowHibernation=${allow}
        AllowHybridSleep=${allow}
        AllowSuspendThenHibernate=${allow}
        HibernateMode=shutdown
      '';
  };
}
