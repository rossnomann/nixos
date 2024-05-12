{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.powertop ];
  powerManagement.powertop.enable = true;
  services.logind = {
    extraConfig = ''
    IdleAction=ignore
    '';
    killUserProcesses = true;
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
    HibernateMode=shutdown
  '';
}
