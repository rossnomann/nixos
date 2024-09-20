lib: {
  niri = import ./niri lib;
  dunst = import ./dunst.nix lib;
  gtk = import ./gtk.nix;
  leftwm = import ./leftwm.nix lib;
  macchina = import ./macchina.nix lib;
  mc = import ./mc.nix lib;
  qtct = import ./qtct.nix lib;
  xresources = import ./xresources.nix lib;
}
