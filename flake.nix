{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    makky = {
      url = "github:rossnomann/makky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fretboard = {
      url = "github:rossnomann/fretboard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-ws = {
      url = "github:rossnomann/niri-ws";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xkb = {
      url = "github:rossnomann/xkb";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = import ./src/nih/lib pkgs;
      overlays = import ./src/nih/packages { inherit inputs system; };
      nixosSystem =
        deviceName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit lib;
          modules = [
            inputs.makky.nixosModules.default
            inputs.niri-ws.nixosModules.default
            overlays
            ./src/nih/modules
            ./src/config/base.nix
            (./src/config + "/${deviceName}.nix")
          ];
          specialArgs = {
            inherit (inputs) nixpkgs;
          };
        };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.just ];
        shellHook = ''
          export NPINS_DIRECTORY=$PWD/src/nih/modules/sources/npins
        '';
      };
      nixosConfigurations = {
        legion = nixosSystem "legion";
      };
      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust flake";
        };
      };
    };
}
