{ pkgs, ... }:
{
  services = {
    logind.lidSwitch = "ignore";
    thermald.enable = true;
    tlp.enable = true;
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
