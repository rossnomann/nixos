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
    services.libinput.enable = true;
  };
}
