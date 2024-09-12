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
        tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      in
      {
        enable = true;
        settings.default_session.command = "${tuigreet} --cmd ${cfgLogin.command}";
      };
  };
}
