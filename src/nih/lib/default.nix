pkgs:
pkgs.lib.extend (
  _: prev: {
    nih = {
      catppuccin = import ./catppuccin.nix;
      kdl = import ./kdl.nix prev;
      workspaces = import ./workspaces.nix;
    };
  }
)
