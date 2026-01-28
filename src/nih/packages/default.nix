{ inputs, system }:
_: {
  nixpkgs.overlays = [
    inputs.fretboard.overlays.${system}.default
    (_: prev: {
      inherit (inputs.darkly.packages.${system}) darkly-qt5 darkly-qt6;
      # TODO: remove when https://github.com/NixOS/nixpkgs/issues/461474 is resolved
      # See also https://github.com/NixOS/nixpkgs/issues/466710
      # Don't forget to remove the input as well
      inherit (inputs.nixpkgs20251111.legacyPackages.${system}) deadbeef;
      nih = {
        wallpapers = import ./wallpapers { inherit prev; };
      };
    })
  ];
}
