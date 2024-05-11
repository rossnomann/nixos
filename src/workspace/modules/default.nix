{ ... }:
{
  imports = [
    ./env.nix
    ./net.nix
    ./nixos.nix
    ./programs
    ./security.nix
    ./services.nix
    ./ui
    ./users.nix
    ./utils.nix
    ./vt.nix
  ];
}
