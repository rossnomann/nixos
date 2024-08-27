{ lib, ... }:
{
  imports = [
    ./config.nix
    ./packages.nix
  ];
  options.nih.gui.style = {
    cursors = {
      name = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      size = lib.mkOption { type = lib.types.int; };
    };

    fonts = {
      packages = lib.mkOption { type = lib.types.listOf lib.types.package; };
      monospace = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
      sansSerif = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
      serif = {
        family = lib.mkOption { type = lib.types.str; };
        defaultSize = lib.mkOption { type = lib.types.int; };
      };
    };

    icons = {
      name = lib.mkOption { type = lib.types.str; };
      package = lib.mkOption { type = lib.types.package; };
    };

    packages = {
      cursors = lib.mkOption {
        internal = true;
        type = lib.types.package;
      };
      gtk = lib.mkOption {
        internal = true;
        type = lib.types.package;
      };
      index = lib.mkOption {
        internal = true;
        type = lib.types.package;
      };
      qt = lib.mkOption {
        internal = true;
        type = lib.types.package;
      };
    };
  };
}
