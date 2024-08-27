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
  };
  config = lib.mkIf cfg.enable {
    users.users.${cfgUser.name} = {
      description = cfgUser.description;
      isNormalUser = true;
    };

    home-manager = {
      users.${cfgUser.name} = {
        home.stateVersion = config.system.stateVersion;
      };
    };
  };
}
