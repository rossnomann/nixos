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
  options.nih.programs.graphics.loupe = {
    package = lib.mkOption { type = lib.types.package; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.graphics.loupe.package ];
    nih.programs.graphics.loupe.package = pkgs.loupe;
    nih.xdg.mime.images = "org.gnome.Loupe.desktop";
  };
}
