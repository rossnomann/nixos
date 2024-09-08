{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    makky = {
      url = "github:rossnomann/makky";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      lib = pkgs.lib.extend (
        final: prev:
        (import ./src/lib {
          writeTextFile = pkgs.writeTextFile;
          lib = prev;
        })
      );
      npins = import ./npins;
      nixosWorkspace =
        deviceName:
        inputs.nixpkgs.lib.nixosSystem {
          inherit lib system;
          modules = [
            inputs.makky.nixosModules.default
            ./src/nih
            ./src/config
          ];
          specialArgs = {
            inherit deviceName npins;
          };
        };
    in
    {
      nixosConfigurations = {
        legion = nixosWorkspace "legion";
        yoga = nixosWorkspace "yoga";
      };
      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust flake";
        };
      };
    };
}
