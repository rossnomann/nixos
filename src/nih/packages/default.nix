{ inputs, system }:
_: {
  nixpkgs.overlays = [
    inputs.fretboard.overlays.${system}.default
    (_: prev: {
      nih = {
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
