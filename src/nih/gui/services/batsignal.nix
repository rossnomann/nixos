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
    systemd.user.units."batsignal.service" = {
      name = "batsignal.service";
      enable = true;
      wantedBy = [ "graphical-session.target" ];
      text = ''
        [Service]
        ExecStart=${pkgs.batsignal}/bin/batsignal
        Restart=on-failure
        RestartSec=1
        Type=simple

        [Unit]
        After=graphical-session-pre.target
        Description=batsignal - battery monitor daemon
        PartOf=graphical-session.target
      '';
    };
  };
}
