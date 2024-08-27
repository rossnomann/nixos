{
  description = "NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib.extend (final: prev: (import ./src/lib { lib = prev; }));
      npins = import ./npins;
      nixosWorkspace =
        deviceName:
        lib.nixosSystem {
          inherit lib;
          system = "x86_64-linux";
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./src/nih
            ./src/config
          ];
          specialArgs = inputs // {
            inherit deviceName;
            inherit npins;
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
