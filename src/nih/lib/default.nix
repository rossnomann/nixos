pkgs:
pkgs.lib.extend (
  final: prev: {
    nih = {
      catppuccin = import ./catppuccin.nix;
      kdl = import ./kdl.nix prev;
      workspaces = import ./workspaces.nix;
    };
  }
)
