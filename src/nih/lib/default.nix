pkgs:
pkgs.lib.extend (
  final: prev: {
    nih = {
      catppuccin = import ./catppuccin.nix;
      kdl = import ./kdl.nix prev;
      mime = import ./mime.nix;
      workspaces = import ./workspaces.nix;
    };
  }
)
