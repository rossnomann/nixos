{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  options.nih.user = {
    name = lib.mkOption { type = lib.types.str; };
    description = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
    gpg_signing_key = lib.mkOption { type = lib.types.str; };
    home = {
      root = lib.mkOption {
        internal = true;
        type = lib.types.path;
      };
      file = lib.mkOption {
        internal = true;
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, config, ... }:
            {
              options = {
                source = lib.mkOption { type = lib.types.path; };
                text = lib.mkOption {
                  type = lib.types.nullOr lib.types.lines;
                  default = null;
                };
                target = lib.mkOption { type = lib.types.str; };
                executable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
              };
              config = {
                target = lib.mkDefault name;
                source = lib.mkIf (config.text != null) (
                  lib.mkDefault (
                    lib.nih.store.writeFile {
                      name = config.target;
                      text = config.text;
                      executable = config.executable == true;
                    }
                  )
                );
              };
            }
          )
        );
      };
    };
  };
  config = lib.mkIf cfg.enable {
    makky = {
      enable = true;
      targetRoot = "$HOME";
      metadataPath = "$HOME/.config/makky.metadata";
      files =
        let
          attrs = [
            "source"
            "target"
          ];
          filterValue = n: v: builtins.elem n attrs;
          mapValue = value: lib.attrsets.filterAttrs filterValue value;
          mapFiles = files: builtins.mapAttrs (name: value: (mapValue value)) files;
        in
        mapFiles cfgUser.home.file;
    };
    nih.user.home = {
      root = config.users.users.${cfgUser.name}.home;
    };
    users.users.${cfgUser.name} = {
      description = cfgUser.description;
      isNormalUser = true;
    };
  };
}
