{ config, lib, ... }:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.variables = {
      PGPASSFILE = "$XDG_CONFIG_HOME/psql/pass";
      PGSERVICEFILE = "$XDG_CONFIG_HOME/psql/service.conf";
      PSQL_HISTORY = "$XDG_DATA_HOME/psql/history";
      PSQLRC = "$XDG_CONFIG_HOME/psql/config";
    };
  };
}
