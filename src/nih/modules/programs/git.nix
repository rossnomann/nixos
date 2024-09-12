{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgStyle = cfg.style;
  cfgUser = cfg.user;
in
{
  options.nih.programs.git = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.git;
    };
    executable = lib.mkOption {
      type = lib.types.str;
      default = "${cfgPrograms.git.package}/bin/git";
    };
    gpgProgram = lib.mkOption { type = lib.types.str; };
    ignore = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.git.package ];
    nih.user.home.file = {
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
        gpg.program = cfgPrograms.git.gpgProgram;
        pull.ff = "only";
        init.defaultBranch = "master";
        include.path = "${npins.catppuccin-delta}/catppuccin.gitconfig";
        delta.features = "catppuccin-${cfgStyle.palette.variant}";
      };
      ".config/git/ignore".text = lib.strings.concatStringsSep "\n" cfgPrograms.git.ignore;
    };
  };
}
