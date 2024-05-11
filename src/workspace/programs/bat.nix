{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    programs.bat = {
      enable = true;
      config.theme = "Catppuccin Mocha";
      themes = {
        "Catppuccin Mocha" = {
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/bat/d714cc1d358ea51bfc02550dabab693f70cccea0/themes/Catppuccin%20Mocha.tmTheme";
            sha256 = "sha256-UDJ6FlLzwjtLXgyar4Ld3w7x3/zbbBfYLttiNDe4FGY=";
          };
        };
      };
    };
  };
}
