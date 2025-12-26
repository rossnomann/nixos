pkgs:
pkgs.lib.extend (
  final: prev: {
    nih = {
      gen = import ./gen prev;
      catppuccin = import ./catppuccin.nix;
      mime = import ./mime.nix;
      workspaces = import ./workspaces.nix;
    };
  }
)
