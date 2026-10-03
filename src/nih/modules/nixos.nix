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
      gc = {
        automatic = true;
        dates = [ "Sat" ];
      };
      optimise = {
        automatic = true;
        dates = [ "Sat" ];
      };
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        nix-path = [ "nixpkgs=${nixpkgs}" ];
      };
    };
    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
    programs.nix-ld.enable = true;
    system.stateVersion = "23.11";
  };
}
