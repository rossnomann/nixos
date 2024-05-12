# Lenovo Legion 5 15IAH7H
{ lib, ... }:
{
  imports = [
    ./autorandr.nix
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./power.nix
    ./syncthing.nix
  ];
  config = {
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    workspace.ui = {
      cursorTheme.size = 16;
      dpi = 144;
      font =
        let
          defaultSize = 10;
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
        gutterSize = 12;
        marginSize = 6;
      };
    };
  };
}
