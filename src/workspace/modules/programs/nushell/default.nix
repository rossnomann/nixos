{ ... }:
{
  workspace.home.xdg.configFile = {
    "nushell/config.nu".source = ./resources/config.nu;
    "nushell/env.nu".source = ./resources/env.nu;
  };
}
