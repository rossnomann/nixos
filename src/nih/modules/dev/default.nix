{ ... }:
{
  imports = [
    ./android.nix
    ./docker.nix
    ./postgres.nix
    ./python.nix
    ./redis.nix
    ./sqlite.nix
  ];
}
