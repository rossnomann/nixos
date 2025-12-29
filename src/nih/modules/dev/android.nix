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
      ANDROID_HOME = "$XDG_DATA_HOME/android/sdk";
      ANDROID_USER_HOME = "$XDG_DATA_HOME/android";
    };
  };
}
