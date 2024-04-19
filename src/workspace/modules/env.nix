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
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    };
  };

  home-manager.users.${config.workspace.user.name} = {
    xdg = {
      enable = true;

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
          publicShare = "${homeDirectory}/workspace/sync";
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
