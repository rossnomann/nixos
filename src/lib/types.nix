{
  lib,
  writeTextFile,
  mkStoreFileName,
}:
{
  file = lib.types.attrsOf (
    lib.types.submodule (
      { name, config, ... }:
      {
        options = {
          executable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          source = {
            path = lib.mkOption { type = lib.types.path; };
            text = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              default = null;
            };
          };
          storeName = lib.mkOption { type = lib.types.str; };
          target = lib.mkOption { type = lib.types.str; };
        };
        config = {
          target = lib.mkDefault name;
          storeName = lib.mkDefault (mkStoreFileName "nih_" name);
          source.path = lib.mkIf (config.source.text != null) (
            lib.mkDefault (writeTextFile {
              name = config.storeName;
              text = config.source.text;
              executable = config.executable == true;
            })
          );
        };
      }
    )
  );
}
