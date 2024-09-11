{
  deviceName,
  pkgs,
  ...
}:
{
  imports = [ (./. + "/${deviceName}.nix") ];
  config = {
    nih = {
      enable = true;
      ui = {
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
      xdg.userDirs = {
        desktop = "$HOME/workspace";
        documents = "$HOME/workspace";
        download = "$HOME/workspace/downloads";
        music = "$HOME/workspace/music";
        pictures = "$HOME/workspace/pictures";
        publicShare = "$HOME/workspace/exchange";
        templates = "$HOME/workspace/templates";
        videos = "$HOME/workspace/videos";
      };
    };
  };
}
