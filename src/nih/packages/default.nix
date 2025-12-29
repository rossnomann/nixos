{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nih = {
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
