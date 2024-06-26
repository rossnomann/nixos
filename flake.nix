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
      nixosWorkspace =
        deviceName:
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./src/workspace ];
          specialArgs = inputs // {
            inherit deviceName;
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
          path = ./src/templates/rust;
          description = "Rust flake";
        };
      };
    };
}
