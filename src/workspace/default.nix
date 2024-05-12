{
  config,
  deviceName,
  home-manager,
  lib,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    (./devices + "/${deviceName}")
    ./env.nix
    ./net.nix
    ./nixos.nix
    ./programs
    ./security.nix
    ./services.nix
    ./ui
    ./users.nix
    ./utils.nix
    ./vt.nix
  ];
  options = with lib; {
    workspace = {
      ui = {
        cursorTheme = {
          name = mkOption { type = types.str; };
          package = mkOption { type = types.package; };
          size = mkOption { type = types.int; };
        };
        dpi = mkOption { type = types.int; };
        font = {
          packages = mkOption { type = types.listOf types.package; };
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
        gtkTheme = {
          name = mkOption { type = types.str; };
          package = mkOption { type = types.package; };
        };
        iconTheme = {
          name = mkOption { type = types.str; };
          package = mkOption { type = types.package; };
        };
        palette = mkOption {
          internal = true;
          type = types.attrs;
        };
        qtTheme = {
          platformThemeName = mkOption { type = types.str; };
          styleName = mkOption { type = types.str; };
          kvantumTheme = {
            name = mkOption { type = types.str; };
            package = mkOption { type = types.package; };
          };
        };
        wm = {
          gutterSize = mkOption { type = types.int; };
          marginSize = mkOption { type = types.int; };
        };
      };
      user = {
        name = mkOption { type = types.str; };
        description = mkOption { type = types.str; };
        email = mkOption { type = types.str; };
        groups = mkOption { type = types.listOf types.str; };
        gpg_signing_key = mkOption { type = types.str; };
      };
    };
  };
  config = {
    home-manager = {
      users.${config.workspace.user.name} = {
        home.stateVersion = config.system.stateVersion;
      };
    };
  };
}
