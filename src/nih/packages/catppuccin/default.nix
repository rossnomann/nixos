{
  lib,
  npins,
  prev,
}:
{
  cursors = { accent, variant }: prev.callPackage ./cursors.nix { inherit lib accent variant; };
  gtk = { accent, variant }: prev.callPackage ./gtk.nix { inherit accent variant; };
  kvantum = prev.callPackage ./kvantum.nix {
    src = npins.catppuccin-kvantum;
  };
  mpv = prev.callPackage ./mpv.nix {
    src = npins.catppuccin-mpv;
  };
}
