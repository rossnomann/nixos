{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
  cfgXdg = cfg.xdg;
in
{
  options.nih.xdg = {
    userDirs = {
      desktop = lib.mkOption { type = lib.types.str; };
      documents = lib.mkOption { type = lib.types.str; };
      download = lib.mkOption { type = lib.types.str; };
      music = lib.mkOption { type = lib.types.str; };
      pictures = lib.mkOption { type = lib.types.str; };
      publicShare = lib.mkOption { type = lib.types.str; };
      templates = lib.mkOption { type = lib.types.str; };
      videos = lib.mkOption { type = lib.types.str; };
    };
    mime = {
      archives = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      audio = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      directories = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      documents = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      images = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      text = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      torrents = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
      videos = lib.mkOption {
        internal = true;
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      etc = {
        "xdg/user-dirs.conf".text = ''
          enabled=False
        '';
        "xdg/user-dirs.defaults".text = ''
          XDG_DESKTOP_DIR="${cfgXdg.userDirs.desktop}"
          XDG_DOCUMENTS_DIR="${cfgXdg.userDirs.documents}"
          XDG_DOWNLOAD_DIR="${cfgXdg.userDirs.download}"
          XDG_MUSIC_DIR="${cfgXdg.userDirs.music}"
          XDG_PICTURES_DIR="${cfgXdg.userDirs.pictures}"
          XDG_PUBLICSHARE_DIR="${cfgXdg.userDirs.publicShare}"
          XDG_TEMPLATES_DIR="${cfgXdg.userDirs.templates}"
          XDG_VIDEOS_DIR="${cfgXdg.userDirs.videos}"
        '';
      };
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_DESKTOP_DIR = cfgXdg.userDirs.desktop;
        XDG_DOCUMENTS_DIR = cfgXdg.userDirs.documents;
        XDG_DOWNLOAD_DIR = cfgXdg.userDirs.download;
        XDG_MUSIC_DIR = cfgXdg.userDirs.music;
        XDG_PICTURES_DIR = cfgXdg.userDirs.pictures;
        XDG_PUBLICSHARE_DIR = cfgXdg.userDirs.publicShare;
        XDG_TEMPLATES_DIR = cfgXdg.userDirs.templates;
        XDG_VIDEOS_DIR = cfgXdg.userDirs.videos;
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
    xdg.mime =
      let
        mkAssoc =
          { entry, mimes }:
          builtins.listToAttrs (
            map (v: {
              name = v;
              value = entry;
            }) mimes
          );
        assoc =
          (mkAssoc {
            entry = cfgXdg.mime.archives;
            mimes = lib.nih.mime.types.archives;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.audio;
            mimes = lib.nih.mime.types.audio;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.directories;
            mimes = lib.nih.mime.types.directories;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.documents;
            mimes = lib.nih.mime.types.documents;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.images;
            mimes = lib.nih.mime.types.images;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.text;
            mimes = lib.nih.mime.types.text;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.torrents;
            mimes = lib.nih.mime.types.torrents;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.videos;
            mimes = lib.nih.mime.types.videos;
          });
      in
      {
        enable = true;
        addedAssociations = assoc;
        defaultApplications = assoc;
      };
  };
}
