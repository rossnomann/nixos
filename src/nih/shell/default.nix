{ lib, ... }:
{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./fs.nix
    ./git.nix
    ./gnupg.nix
    ./macchina.nix
    ./mc.nix
    ./net.nix
    ./nushell.nix
    ./sys.nix
  ];
}
