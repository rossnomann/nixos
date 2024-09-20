{
  lib,
  ...
}:
{
  options.nih.windowRules = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          x11Class = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          waylandAppId = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          title = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          useWorkspace = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          useFullscreen = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
          };
          useFloating = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
          };
        };
      }
    );
    default = [ ];
  };
}
