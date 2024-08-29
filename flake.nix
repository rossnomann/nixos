{
  description = "NixOS configuration";
  # TODO: use nixpkgs from npins
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
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
            ./src/nih
            ./src/config
          ];
          specialArgs = inputs // {
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
