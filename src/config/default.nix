{
  config,
  deviceName,
  lib,
  pkgs,
  ...
}:
{
  imports = [ (./. + "/${deviceName}.nix") ];
  config = {
    nih = {
      enable = true;
      gui = {
        style = {
          fonts = {
            packages = [
              pkgs.roboto
              pkgs.roboto-serif
              pkgs.fira-code
              pkgs.fira-code-symbols
            ];
            monospace = {
              family = "Fira Code";
            };
            sansSerif = {
              family = "Roboto";
            };
            serif = {
              family = "Roboto Serif";
            };
          };
          icons = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };
      };
      locale = {
        default = "en_US.UTF-8";
        extra = "ru_RU.UTF-8";
        timeZone = "Europe/Bratislava";
      };
      palette = {
        accent = "green";
        variant = "mocha";
      };
      user = {
        name = "ross";
        description = "Ross Nomann";
        email = "rossnomann@protonmail.com";
        gpg_signing_key = "56D1FCBF";
      };
    };
  };
}
