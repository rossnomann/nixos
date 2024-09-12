{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.variables = {
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    };
    programs.less.enable = true;
  };
}
