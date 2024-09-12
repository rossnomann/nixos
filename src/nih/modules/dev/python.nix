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
    environment.systemPackages = [ pkgs.python312Full ];
    environment.variables = {
      PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
      PYTHON_HISTORY = "$XDG_DATA_HOME/python/history";
    };
    nih.user.home.file = {
      ".config/python/pythonrc" = {
        executable = true;
        text = ''
          #!/usr/bin/env python


          def __setup_history():
              import atexit
              import os
              import readline
              import sys

              from contextlib import suppress
              from pathlib import Path

              if hasattr(sys, "__interactivehook__"):
                  del sys.__interactivehook__

              if data_home := os.environ.get("XDG_DATA_HOME"):
                  data_home = Path(data_home)
              else:
                  data_home = Path.home() / ".local" / "share"
              if not data_home.is_dir():
                  print("Error: XDG_DATA_HOME does not exist at", data_home)

              history_path = data_home / "python" / "history"
              if not history_path.parent.is_dir():
                  history_path.parent.mkdir()
              history_path.touch(exist_ok=True)

              with suppress(OSError):
                  readline.read_history_file(history_path)
              readline.set_history_length(5000)
              atexit.register(readline.write_history_file, history_path)


          __setup_history()
        '';
      };
    };
  };
}
