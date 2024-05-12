# Lenovo Yoga 7 14ITL5
{ lib, ... }:
{
  imports = [
    ./autorandr.nix
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./power.nix
    ./syncthing.nix
    ./tablet.nix
  ];
  config = {
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    workspace.ui = {
      cursorTheme.size = 14;
      dpi = 144;
      font =
        let
          defaultSize = 8;
        in
        {
          monospace = {
            inherit defaultSize;
          };
          sansSerif = {
            inherit defaultSize;
          };
          serif = {
            inherit defaultSize;
          };
        };
      wm = {
        gutterSize = 6;
        marginSize = 3;
      };
    };
  };
}
