{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.im.slack = {
    enable = lib.mkEnableOption "Slack";
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.im.slack.enable) {
    environment.systemPackages = [ cfgPrograms.im.slack.package ];
    nih.programs.im.slack.package = pkgs.slack;
    nih.windowRules = [
      {
        appId = ''^Slack'';
        workspace = "secondary";
      }
    ];
  };
}
