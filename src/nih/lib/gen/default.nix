lib: {
  dunst = import ./dunst.nix lib;
  gtk = import ./gtk.nix;
  kdl = import ./kdl.nix lib;
  macchina = import ./macchina.nix lib;
  mc = import ./mc.nix lib;
  xresources = import ./xresources.nix lib;
}
