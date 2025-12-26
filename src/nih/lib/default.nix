pkgs:
pkgs.lib.extend (
  final: prev: {
    nih = {
      gen = import ./gen prev;
      catppuccin = import ./catppuccin.nix;
      mime = import ./mime.nix;
      strings = import ./strings.nix prev;
      workspaces = import ./workspaces.nix;
    };
  }
)
