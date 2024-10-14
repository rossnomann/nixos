{
  lib,
  prev,
}:
{
  cursors = { accent, variant }: prev.callPackage ./cursors.nix { inherit lib accent variant; };
  gtk = { accent, variant }: prev.callPackage ./gtk.nix { inherit accent variant; };
  kvantum = { src }: prev.callPackage ./kvantum.nix { inherit src; };
  mpv = { src }: prev.callPackage ./mpv.nix { inherit src; };
}
