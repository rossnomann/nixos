{ npins, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nih = {
        catppuccin = import ./catppuccin { inherit npins prev; };
        mc = import ./mc { inherit prev; };
        nohup-xdg-open = import ./nohup-xdg-open { inherit prev; };
        rlaunchx = import ./rlaunchx { inherit prev; };
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
