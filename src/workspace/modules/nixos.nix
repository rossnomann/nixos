{ config, lib, ... }:
{
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  system.stateVersion = "23.11";
}
