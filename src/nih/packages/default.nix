{ inputs, system }:
_: {
  nixpkgs.overlays = [
    inputs.fretboard.overlays.${system}.default
    (_: prev: {
      inherit (inputs.darkly.packages.${system}) darkly-qt5 darkly-qt6;
      nih = {
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
