qa:
    find ./ -name '*.nix' -not -path '*/sources/npins/*' -exec nixf-diagnose {} +
    statix check src/ --ignore src/nih/modules/sources/npins/default.nix
    statix check flake.nix
    deadnix src/ flake.nix
    treefmt flake.nix src --fail-on-change
