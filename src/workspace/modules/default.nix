{ ... }:
{
  imports = [
    ./docker.nix
    ./env.nix
    ./net.nix
    ./nixos.nix
    ./programs
    ./python
    ./security.nix
    ./services.nix
    ./ui
    ./users.nix
    ./utils.nix
  ];
}
