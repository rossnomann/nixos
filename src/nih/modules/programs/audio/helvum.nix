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
  options.nih.programs.audio.helvum = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.audio.helvum.package ];
    nih.programs.audio.helvum.package = pkgs.helvum;
    nih.windowRules = [
      {
        x11Class = "helvum";
        waylandAppId = "org.pipewire.Helvum";
        useWorkspace = "audio";
      }
    ];
  };
}
