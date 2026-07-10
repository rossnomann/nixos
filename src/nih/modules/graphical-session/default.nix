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
      windowRules =
        let
          defaultSizeType = lib.types.submodule {
            options = {
              fixed = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              value = lib.mkOption {
                type = lib.types.oneOf [lib.types.int lib.types.float];
              };
            };
          } ;
        in
        lib.mkOption {
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
                defaultHeight = lib.mkOption {
                  type = lib.types.nullOr defaultSizeType;
                  default = null;
                };
                defaultWidth = lib.mkOption {
                  type = lib.types.nullOr defaultSizeType;
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
