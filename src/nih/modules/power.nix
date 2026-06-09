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
    suspend.enable = lib.mkEnableOption "suspend";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.power-profiles-daemon ];
    services = {
      logind.settings.Login = {
        HandleLidSwitch = if cfgPower.suspend.enable then "suspend-then-hibernate" else "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = if cfgPower.suspend.enable then "suspend" else "ignore";
        HandlePowerKey = "ignore";
        HandlePowerKeyLongPress = "poweroff";
        IdleAction = "ignore";
        KillUserProcesses = true;
      };
      power-profiles-daemon.enable = true;
      thermald.enable = true;
    };
    systemd.sleep.settings =
      let
        allow = if cfgPower.suspend.enable then "yes" else "no";
      in
      {
        Sleep = {
          AllowSuspend = allow;
          AllowHibernation = allow;
          AllowHybridSleep = allow;
          AllowSuspendThenHibernate = allow;
          HibernateMode = "shutdown";
        };
      };
  };
}
