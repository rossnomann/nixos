{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
  cfgUser = cfg.user;
  p = {
    bat = pkgs.bat;
    gnupg = pkgs.gnupg;
    nohupXdgOpen = pkgs.writeShellScriptBin "nohup-xdg-open" ''
      ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
    '';
  };
in
{
  options.nih.programs.cli = {
    git.ignore = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      p.bat
      p.gnupg
      pkgs.android-tools
      pkgs.curl
      pkgs.direnv
      pkgs.exiftool
      pkgs.file
      pkgs.git
      pkgs.helix
      pkgs.htop
      pkgs.imagemagick
      pkgs.lame
      pkgs.lshw
      pkgs.macchina
      pkgs.mc
      pkgs.mergiraf
      pkgs.pciutils
      pkgs.trash-cli
      pkgs.unrar
      pkgs.usbutils
      pkgs.wget
    ];
    environment.variables = {
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
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
        ".config/git/config".text = lib.generators.toGitINI {
          user = {
            email = cfgUser.email;
            name = cfgUser.description;
            signingkey = cfgUser.gpg_signing_key;
          };
          core =
            let
              nano = "${pkgs.nano}/bin/nano";
              delta = "${pkgs.delta}/bin/delta";
            in
            {
              autocrlf = "input";
              editor = nano;
              excludesfile = "~/.config/git/ignore";
              pager = "${delta}";
            };
          alias = {
            st = "status";
            ci = "commit";
          };
          gpg.program = "${p.gnupg}/bin/gpg";
          pull.ff = "only";
          init.defaultBranch = "master";
          include.path = "${cfgSources.catppuccin-delta}/catppuccin.gitconfig";
          delta.features = "catppuccin-${cfgStyle.palette.variant}";
        };
        ".config/git/ignore".text = lib.strings.concatStringsSep "\n" cfgPrograms.cli.git.ignore;
        ".local/share/gnupg/gpg.conf".text = ''
          no-greeting
          use-agent
          pinentry-mode loopback
        '';
        ".config/direnv/direnv.toml".text = ''
          [global]
          hide_env_diff = true
          warn_timeout = 0
        '';
        ".config/direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
        ".config/helix/config.toml".text = import ./resources/helix.nix palette;
        ".config/helix/themes/catppuccin-${palette.variant}.toml".source =
          "${cfgSources.catppuccin-helix}/themes/default/catppuccin_${palette.variant}.toml";
        ".config/macchina/macchina.toml".source = ./resources/macchina-config.toml;
        ".config/macchina/themes/default.toml".source = ./resources/macchina-theme.toml;
        ".config/mc/ini".source = ./resources/mc.ini;
        ".config/mc/mc.ext.ini".text =
          let
            xdgOpen = "${p.nohupXdgOpen}/bin/nohup-xdg-open";
          in
          lib.generators.toINI { } {
            "mc.ext.ini" = {
              Version = 4.0;
            };
            Default = {
              Open = "${xdgOpen} %d/%p";
              View = "${xdgOpen} %d/%p";
            };
          };
        ".local/share/mc/skins/catppuccin.ini".source = "${cfgSources.catppuccin-mc}/catppuccin.ini";
      };
    nih.xdg.mime.text = "Helix.desktop";
  };
}
