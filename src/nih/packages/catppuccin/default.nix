{ npins, prev }:
{
  kvantum = prev.callPackage ./kvantum.nix {
    src = npins.catppuccin-kvantum;
  };
  mpv = prev.callPackage ./mpv.nix {
    src = npins.catppuccin-mpv;
  };
}
