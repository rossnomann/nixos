{
  config,
  lib,
  nixpkgs,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.npins
    ];
    nix = {
      gc.automatic = true;
      nixPath = [ "nixpkgs=${nixpkgs}" ];
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
  };
}
