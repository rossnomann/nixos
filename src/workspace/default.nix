{
  config,
  home-manager,
  lib,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./modules
  ];
  options = with lib; {
    workspace = {
      theme = {
        font = {
          monospace = {
            family = mkOption { type = types.str; };
            defaultSize = mkOption { type = types.int; };
          };
          sansSerif = {
            family = mkOption { type = types.str; };
            defaultSize = mkOption { type = types.int; };
          };
          serif = {
            family = mkOption { type = types.str; };
            defaultSize = mkOption { type = types.int; };
          };
        };
        palette = mkOption {
          internal = true;
          type = types.attrs;
        };
      };
      user = {
        name = mkOption { type = types.str; };
        description = mkOption { type = types.str; };
        email = mkOption { type = types.str; };
        groups = mkOption { type = types.listOf lib.types.str; };
      };
    };
  };
  config = {
    home-manager = {
      users.${config.workspace.user.name} = {
        home.stateVersion = config.system.stateVersion;
        xdg.enable = true;
      };
    };
  };
}
