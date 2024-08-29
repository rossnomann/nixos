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
    home = lib.mkOption {
      internal = true;
      type = lib.types.path;
    };
  };
  config = lib.mkIf cfg.enable {
    nih.user.home = config.users.users.${cfgUser.name}.home;

    users.users.${cfgUser.name} = {
      description = cfgUser.description;
      isNormalUser = true;
    };

    home-manager.users.${cfgUser.name}.home.stateVersion = config.system.stateVersion;
  };
}
