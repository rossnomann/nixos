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
    services.getty = {
      greetingLine = ''\l ${config.system.nixos.label}'';
      helpLine = "";
    };
    services.greetd =
      let
        tuigreet = "${pkgs.tuigreet}/bin/tuigreet --remember-session";
      in
      {
        enable = true;
        settings.default_session.command = "${tuigreet}";
        useTextGreeter = true;
      };
  };
}
