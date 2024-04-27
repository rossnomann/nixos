{ config, ... }:
{
  environment.variables = {
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    PYTHON_HISTORY = "$XDG_DATA_HOME/python/history";
  };
  home-manager.users.${config.workspace.user.name}.xdg.configFile."python/pythonrc".source = ./resources/pythonrc;
}
