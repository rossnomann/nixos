{
  config,
  lib,
  pkgs,
  pkgs20251111,
  ...
}:
let
  cfg = config.nih;
in
{
  imports = [
    ./ardour
    ./alacritty.nix
    ./firefox.nix
    ./fretboard.nix
    ./gimp.nix
    ./inkscape.nix
    ./mpv.nix
    ./obsidian.nix
    ./rofi.nix
    ./sublime.nix
    ./telegram.nix
    ./zathura.nix
  ];
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs20251111.deadbeef
      pkgs.discord
      pkgs.helvum
      pkgs.libreoffice
      pkgs.loupe
      pkgs.overskride
      pkgs.pavucontrol
      pkgs.slack
      pkgs.scrcpy
      pkgs.simple-scan
      pkgs.steam
      pkgs.syncplay
      pkgs.transmission_4-gtk
      pkgs.xarchiver
    ];
    nih.graphicalSession.windowRules = [
      {
        appId = ''^deadbeef'';
        workspace = "secondary";
      }
      {
        appId = ''^discord'';
        workspace = "secondary";
      }
      {
        appId = ''^org\\.pipewire\\.Helvum'';
        workspace = "audio";
      }
      {
        appId = ''^libreoffice'';
        workspace = "main";
      }
      {
        appId = ''^Slack'';
        workspace = "secondary";
      }
      {
        appId = ''^steam'';
        fullscreen = true;
        workspace = "games";
      }
      {
        appId = ''^syncplay'';
        workspace = "main";
        floating = true;
      }
      {
        appId = ''^transmission'';
        workspace = "main";
      }
    ];
    nih.xdg.mime = {
      archives = "xarchiver.desktop";
      images = "org.gnome.Loupe.desktop";
      torrents = "transmission-gtk.desktop";
    };
  };
}
