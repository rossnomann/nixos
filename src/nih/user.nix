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
  imports = [
    (lib.mkAliasOptionModule
      [
        "nih"
        "user"
        "home"
        "file"
      ]
      [
        "makky"
        "files"
      ]
    )
  ];
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
    };
  };
  config = lib.mkIf cfg.enable {
    makky = {
      enable = true;
      targetRoot = "$HOME";
      metadataPath = "$HOME/.config/makky.metadata";
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
