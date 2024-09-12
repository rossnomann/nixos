{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sqlite ];
    environment.variables = {
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite/history";
    };
  };
}
