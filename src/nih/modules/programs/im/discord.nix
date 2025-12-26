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
  options.nih.programs.im.discord = {
    enable = lib.mkEnableOption "Discord";
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf (cfg.enable && cfgPrograms.im.discord.enable) {
    environment.systemPackages = [ cfgPrograms.im.discord.package ];
    nih.programs.im.discord.package = pkgs.discord;
    nih.windowRules = [
      {
        appId = ''^discord'';
        workspace = "secondary";
      }
    ];
  };
}
