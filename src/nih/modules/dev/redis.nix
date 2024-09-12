{ config, lib, ... }:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.variables = {
      REDISCLI_HISTFILE = "$XDG_DATA_HOME/redis/history";
      REDISCLI_RCFILE = "$XDG_CONFIG_HOME/redis/config";
    };
  };
}
