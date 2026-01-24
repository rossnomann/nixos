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
    inherit (pkgs)
      android-tools
      bat
      curl
      deadnix
      delta
      direnv
      git
      gnupg
      helix
      mergiraf
      nixd
      nixf-diagnose
      nixfmt
      nixfmt-tree
      python314
      sqlite
      statix
      wget
      ;
  };
  exe = {
    bat = lib.getExe p.bat;
    delta = lib.getExe p.delta;
    gnupg = lib.getExe p.gnupg;
    helix = lib.getExe p.helix;
  };
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
      EDITOR = exe.helix;
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      HISTFILE = "$XDG_DATA_HOME/bash-history";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      MANPAGER = "${exe.bat} -plman";
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
      ${exe.bat} cache --build
    '';
    users.users.${cfgUser.name}.extraGroups = [ "docker" ];
    virtualisation.docker.enable = true;

    nih.user.home.file =
      let
        inherit (cfgStyle) palette;
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
            lib
            cfgSources
            cfgStyle
            cfgUser
            ;
          editor = exe.helix;
          gpg = exe.gnupg;
          pager = exe.delta;
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
