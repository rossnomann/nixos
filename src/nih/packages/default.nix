{ ... }:
{
  nixpkgs.overlays = [
    (_: prev: {
      nih = {
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
