{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  p = {
    nohupXdgOpen = pkgs.writeShellScriptBin "nohup-xdg-open" ''
      ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.exiftool
      pkgs.file
      pkgs.htop
      pkgs.imagemagick
      pkgs.lame
      pkgs.lshw
      pkgs.macchina
      pkgs.mc
      pkgs.pciutils
      pkgs.trash-cli
      pkgs.unrar
      pkgs.usbutils
      pkgs.wiremix
    ];
    nih.user.home.file = {
      ".config/macchina/macchina.toml".source = ./resources/cli/macchina-config.toml;
      ".config/macchina/themes/default.toml".source = ./resources/cli/macchina-theme.toml;
      ".config/mc/ini".source = ./resources/cli/mc.ini;
      ".config/mc/mc.ext.ini".text =
        let
          xdgOpen = "${p.nohupXdgOpen}/bin/nohup-xdg-open";
        in
        lib.generators.toINI { } {
          "mc.ext.ini" = {
            Version = 4.0;
          };
          Default = {
            Open = "${xdgOpen} %d/%p";
            View = "${xdgOpen} %d/%p";
          };
        };
      ".local/share/mc/skins/catppuccin.ini".source = "${cfgSources.catppuccin-mc}/catppuccin.ini";
    };
  };
}
