{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        PATH = [ "$HOME/.local/bin" ];
      };
      variables = {
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        ANDROID_HOME = "$XDG_DATA_HOME/android/sdk";
        ANDROID_USER_HOME = "$XDG_DATA_HOME/android";
        ANSIBLE_HOME = "$XDG_DATA_HOME/ansible";
        AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
        AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
        AWS_VAULT_FILE_DIR = "$XDG_DATA_HOME/awsvault";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
        DOTNET_CLI_HOME = "$XDG_DATA_HOME/dotnet";
        FFMPEG_DATADIR = "$XDG_CONFIG_HOME/ffmpeg";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
        HISTFILE = "$XDG_DATA_HOME/bash/history";
        INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
        LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
        PGPASSFILE = "$XDG_CONFIG_HOME/psql/pass";
        PGSERVICEFILE = "$XDG_CONFIG_HOME/psql/service.conf";
        PSQL_HISTORY = "$XDG_DATA_HOME/psql/history";
        PSQLRC = "$XDG_CONFIG_HOME/psql/config";
        PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
        PYTHON_HISTORY = "$XDG_DATA_HOME/python/history";
        REDISCLI_HISTFILE = "$XDG_DATA_HOME/redis/history";
        REDISCLI_RCFILE = "$XDG_CONFIG_HOME/redis/config";
        SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite/history";
        WINEPREFIX = "$XDG_DATA_HOME/wine";
      };
    };

    home-manager.users.${cfgUser.name} = {
      xdg = {
        enable = true;
        mimeApps.enable = true;

        configFile = {
          "mimeapps.list".force = true;
          "python/pythonrc" = {
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
        userDirs =
          let
            homeDirectory = config.home-manager.users.${cfgUser.name}.home.homeDirectory;
          in
          {
            enable = true;

            desktop = "${homeDirectory}/workspace";
            documents = "${homeDirectory}/workspace/documents";
            download = "${homeDirectory}/workspace/downloads";
            music = "${homeDirectory}/workspace/music";
            pictures = "${homeDirectory}/workspace/pictures";
            publicShare = "${homeDirectory}/workspace/exchange";
            templates = "${homeDirectory}/workspace/templates";
            videos = "${homeDirectory}/workspace/videos";
          };
      };
    };
  };
}
