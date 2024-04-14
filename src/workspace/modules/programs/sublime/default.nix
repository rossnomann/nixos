{ config, pkgs, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    # https://github.com/sublimehq/sublime_text/issues/5984
    "openssl-1.1.1w"
  ];
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [ pkgs.sublime4 ];
    # Contains only simple packages without deps, e.g. preferences, syntax highlighting, color schemes, etc...
    xdg.configFile = {
      "sublime-text/Installed Packages/Dockerfile.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/asbjornenge/Docker.tmbundle/archive/refs/tags/v1.6.4.zip";
        hash = "sha256-2LS9ByB/j4FX5Mym/W2u6yx/0G3fGvy5vfaQM7I8zNA=";
      };
      "sublime-text/Installed Packages/FileIconsMono.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/braver/FileIcons/archive/refs/tags/mono-2.0.4.zip";
        hash = "sha256-9faQarel+9aT8hih+jkHpUAsm6w76HE/ZajBfhIi32Q=";
      };
      "sublime-text/Installed Packages/GitGutter.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/jisaacks/GitGutter/archive/refs/tags/1.11.12.zip";
        hash = "sha256-hNXz1YxoKPW+yIYI4LvZm70LrFFkXDDI6GToOtg9TJk=";
      };
      "sublime-text/Packages/User/GitGutter.sublime-settings".text = ''
        {
          "show_line_annotation": false
        }
      '';
      "sublime-text/Installed Packages/Jinja2.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/Sublime-Instincts/BetterJinja/archive/refs/tags/v1.1.0.zip";
        hash = "sha256-piaFk6Hoy6flAg4taRdOE3upNonH9iMhe7TpJ0ouLyE=";
      };
      "sublime-text/Installed Packages/Nix.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/wmertens/sublime-nix/archive/9032bd613746b9c135223fd6f26a5fa555f18946.zip";
        hash = "sha256-slvn5n+jvJmPuapnPC3TIZEBpw2Qivx3GhhonVGJ5HU=";
      };
      "sublime-text/Installed Packages/Nushell.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/stevenxxiu/sublime_text_nushell/archive/refs/tags/v1.11.0.zip";
        hash = "sha256-xGgRMD8w++F0R3JCUTK7kf/Mc1YsWxovwskyr8G1rEI=";
      };
      "sublime-text/Installed Packages/TOML.sublime-package".source = pkgs.fetchurl {
        url = "https://github.com/jasonwilliams/sublime_toml_highlighting/archive/refs/tags/v2.5.0.zip";
        hash = "sha256-Wuq3cp+0clD1pB/hkGxNfv1tbCL2moCCLR3p3DlRfPo=";
      };
      "sublime-text/Packages/Catppuccin/mocha.sublime-color-scheme".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/sublime-text/222603541e5c23a5f6d54207898b47da91856274/Catppuccin%20Mocha.sublime-color-scheme";
        hash = "sha256-q3t9Lc9fwAMiAm+XoXo972HTC8mYF2vVs55SDMvwSI4=";
      };
      "sublime-text/Packages/Catppuccin/Preferences.sublime-settings".text =
        let
          font = config.workspace.theme.font.monospace;
        in
        ''
          {
            "font_face": "${font.family}",
            "font_size": ${builtins.toString font.defaultSize},
            "color_scheme": "mocha.sublime-color-scheme",
            "theme": "Adaptive.sublime-theme",
          }
        '';
      "sublime-text/Packages/NixOS".source = ./resources/packages/NixOS;
    };
  };
}
