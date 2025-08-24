{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgLogin = cfg.login;
in
{
  options.nih.login = {
    command = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    services.greetd =
      let
        tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      in
      {
        enable = true;
        settings.default_session.command = "${tuigreet} --cmd ${cfgLogin.command}";
      };
    systemd.user.units."wm-session.target" = {
      name = "wm-session.target";
      enable = true;
      text = ''
        [Unit]
        Description=A window manager session
        Documentation=man:systemd.special
        BindsTo=graphical-session.target
        Wants=graphical-session-pre.target
        After=graphical-session-pre.target nixos-activation.service
      '';
    };
    systemd.user.units."wm-session-post.target" = {
      name = "wm-session-post.target";
      enable = true;
      text = ''
        [Unit]
        Description=Session services which should run after the wm-session is brought up
        Documentation=man:systemd.special(7)
        Requires=basic.target
        After=wm-session.target
        RefuseManualStart=yes
        StopWhenUnneeded=yes
      '';
    };
  };
}
