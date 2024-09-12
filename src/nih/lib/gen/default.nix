lib: {
  dunst = import ./dunst.nix lib;
  gtk = import ./gtk.nix;
  leftwm = import ./leftwm.nix lib;
  mc = import ./mc.nix lib;
}
