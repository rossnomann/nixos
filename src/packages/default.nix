{ npins, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      nih = {
        catppuccin-kvantum = prev.callPackage ./catppuccin-kvantum.nix { src = npins.catppuccin-kvantum; };
        catppuccin-mpv = prev.callPackage ./catppuccin-mpv.nix { src = npins.catppuccin-mpv; };
        mc =
          {
            commandTerminal,
            configIni,
            configExtIni,
            pathSkin,
          }:
          prev.callPackage ./mc.nix {
            inherit
              commandTerminal
              configIni
              configExtIni
              pathSkin
              ;
            mc = prev.mc;
          };
        nohup-xdg-open = prev.callPackage ./nohup-xdg-open.nix { };
      };
    })
  ];
}
