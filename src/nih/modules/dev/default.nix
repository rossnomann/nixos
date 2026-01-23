{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgDev = cfg.dev;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
  cfgUser = cfg.user;
  p = {
    android-tools = pkgs.android-tools;
    bat = pkgs.bat;
    curl = pkgs.curl;
    direnv = pkgs.direnv;
    git = pkgs.git;
    gnupg = pkgs.gnupg;
    helix = pkgs.helix;
    mergiraf = pkgs.mergiraf;
    python314 = pkgs.python314;
    sqlite = pkgs.sqlite;
    wget = pkgs.wget;
  };
  editor = "${p.helix}/bin/hx";
in
{
  options.nih.dev = {
    git.ignore = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.attrValues p;
    environment.variables = {
      ANDROID_HOME = "$XDG_DATA_HOME/android/sdk";
      ANDROID_USER_HOME = "$XDG_DATA_HOME/android";
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      EDITOR = editor;
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      HISTFILE = "$XDG_DATA_HOME/bash-history";
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
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
      settings = {
        allow-loopback-pinentry = "";
      };
    };
    programs.less.enable = true;
    system.userActivationScripts.batCache = ''
      echo "Rebuilding bat theme cache $XDG_CACHE_HOME"
      cd "${pkgs.emptyDirectory}"
      ${lib.getExe p.bat} cache --build
    '';
    users.users.${cfgUser.name}.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;

    nih.user.home.file =
      let
        palette = cfgStyle.palette;
        batThemeName = "Catppuccin ${lib.strings.toSentenceCase palette.variant}";
      in
      {
        ".config/bat/config".text = ''
          --theme='${batThemeName}'
        '';
        ".config/bat/themes/${batThemeName}.tmTheme".source =
          "${cfgSources.catppuccin-bat}/themes/${batThemeName}.tmTheme";
        ".config/git/config".text = import ./resources/git.nix {
          inherit
            editor
            lib
            cfgSources
            cfgStyle
            cfgUser
            ;
          gpg = "${p.gnupg}/bin/gpg";
          pager = "${pkgs.delta}/bin/delta";
        };
        ".config/git/ignore".text = lib.strings.concatStringsSep "\n" cfgDev.git.ignore;
        ".config/direnv/direnv.toml".source = ./resources/direnv.toml;
        ".config/direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
        ".config/helix/config.toml".text = import ./resources/helix.nix palette;
        ".config/helix/themes/catppuccin-${palette.variant}.toml".source =
          "${cfgSources.catppuccin-helix}/themes/default/catppuccin_${palette.variant}.toml";
        ".config/python/pythonrc" = {
          executable = true;
          source = ./resources/pythonrc;
        };
        ".local/share/gnupg/gpg.conf".source = ./resources/gpg.conf;
      };
    nih.xdg.mime.text = "Helix.desktop";
  };
}
