{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  package = (
    pkgs.nih.mc {
      commandTerminal = cfgPrograms.terminal.runCommand;
      configIni = lib.nih.mc.mkIni {
        general = lib.nih.mc.defaults.ini.general // {
          skin = "catppuccin";
        };
      };
      configExtIni = lib.nih.mc.mkExtIni {
        xdgOpen = "${pkgs.nih.nohup-xdg-open}/bin/nohup-xdg-open";
        editImage = "gimp"; # TODO: value from config
      };
      pathSkin = "${npins.catppuccin-mc}/catppuccin.ini";
    }
  );
in
{
  options.nih.programs.commander = {
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      pathsToLink = [ "/share/mc" ];
      systemPackages = [
        cfgPrograms.commander.package
      ];
    };
    nih.xdg.mime.directories = "mc.desktop";
  };
}
