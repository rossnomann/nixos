{ lib, ... }:
{
  imports = [
    ./niri
    ./xkb.nix
    ./xresources.nix
  ];
  options = {
    nih.graphicalSession = {
      dpi = lib.mkOption { type = lib.types.int; };
      windowRules = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              appId = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              title = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              workspace = lib.mkOption {
                type = lib.types.nullOr (lib.types.enum lib.nih.workspaces);
                default = null;
              };
              fullscreen = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              floating = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
            };
          }
        );
        default = [ ];
      };
    };
  };
}
