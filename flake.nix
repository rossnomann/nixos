{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      lib = import ./src/nih/lib pkgs;
      nixosSystem =
        deviceName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit lib;
          modules = [
            inputs.makky.nixosModules.default
            inputs.fretboard.nixosModules.default
            ./src/nih/packages
            ./src/nih/modules
            ./src/config/base.nix
            (./src/config + "/${deviceName}.nix")
          ];
          specialArgs = {
            nixpkgs = inputs.nixpkgs;
            lightly = inputs.lightly;
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
