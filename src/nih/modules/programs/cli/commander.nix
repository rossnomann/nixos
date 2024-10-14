{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.cli.commander = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/mc" ];
    environment.systemPackages = [ cfgPrograms.cli.commander.package ];
    nih.programs.cli.commander.executable = "${cfgPrograms.cli.commander.package}/bin/mc";
    nih.programs.cli.commander.package = pkgs.nih.mc {
      commandTerminal = cfgPrograms.terminal.runCommand;
      configIni = lib.nih.gen.mc.mkIni {
        general = lib.nih.gen.mc.defaults.ini.general // {
          skin = "catppuccin";
        };
      };
      configExtIni = lib.nih.gen.mc.mkExtIni {
        xdgOpen = "${pkgs.nih.nohup-xdg-open}/bin/nohup-xdg-open";
        editRasterImage = cfgPrograms.graphics.gimp.executable;
        editVectorImage = cfgPrograms.graphics.inkscape.executable;
      };
      pathSkin = "${cfgSources.catppuccin-mc}/catppuccin.ini";
    };
    nih.xdg.mime.directories = "mc.desktop";
  };
}
