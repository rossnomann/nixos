{ config, pkgs, ... }:
{
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
      REDISCLI_HISTFILE = "$XDG_DATA_HOME/redis/history";
      REDISCLI_RCFILE = "$XDG_CONFIG_HOME/redis/config";
      SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite/history";
      WINEPREFIX = "$XDG_DATA_HOME/wine";
    };
  };

  home-manager.users.${config.workspace.user.name} = {
    xdg = {
      enable = true;
      mimeApps.enable = true;

      configFile."mimeapps.list".force = true;
      userDirs =
        let
          homeDirectory = config.home-manager.users.${config.workspace.user.name}.home.homeDirectory;
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

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
    supportedLocales = [ "all" ];
  };

  time.timeZone = "Europe/Bratislava";
}
