{
  deviceName,
  config,
  home-manager,
  lib,
  options,
  pkgs,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./modules
  ];
  options = with lib; {
    workspace = {
      deviceName = mkOption {
        type = types.enum [
          "legion"
          "yoga"
        ];
      };
      home = mkOption { type = options.home-manager.users.type.functor.wrapped; };
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
    workspace = {
      inherit deviceName;
      home = (lib.mkAliasDefinitions config.home-manager.users."${config.workspace.user.name}") // {
        home.stateVersion = config.system.stateVersion;
        xdg.enable = true;
      };
    };
  };
}
