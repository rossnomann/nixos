{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs20251111.url = "github:NixOS/nixpkgs?rev=9da7f1cf7f8a6e2a7cb3001b048546c92a8258b4";
    makky = {
      url = "github:rossnomann/makky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lightly = {
      url = "github:Bali10050/Darkly";
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
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      pkgs20251111 = inputs.nixpkgs20251111.legacyPackages.${system};
      lib = import ./src/nih/lib pkgs;
      nixosSystem =
        deviceName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit lib;
          modules = [
            inputs.makky.nixosModules.default
            inputs.niri-ws.nixosModules.default
            ./src/nih/packages
            ./src/nih/modules
            ./src/config/base.nix
            (./src/config + "/${deviceName}.nix")
          ];
          specialArgs = {
            inherit (inputs) fretboard nixpkgs lightly;
            inherit pkgs20251111;
          };
        };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
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
