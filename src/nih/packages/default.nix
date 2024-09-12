{ lib, npins, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nih = {
        catppuccin = import ./catppuccin { inherit lib npins prev; };
        cursor-theme-default = import ./cursor-theme-default { inherit prev; };
        mc = import ./mc { inherit prev; };
        nohup-xdg-open = import ./nohup-xdg-open { inherit prev; };
        rlaunchx = import ./rlaunchx { inherit prev; };
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
