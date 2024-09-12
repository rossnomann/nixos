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
  options.nih.programs.cli.git = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
    gpgProgram = lib.mkOption { type = lib.types.str; };
    ignore = lib.mkOption { type = lib.types.listOf lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.git.package ];
    nih.programs.cli.git.executable = "${cfgPrograms.cli.git.package}/bin/git";
    nih.programs.cli.git.package = pkgs.git;
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
        gpg.program = cfgPrograms.cli.git.gpgProgram;
        pull.ff = "only";
        init.defaultBranch = "master";
        include.path = "${npins.catppuccin-delta}/catppuccin.gitconfig";
        delta.features = "catppuccin-${cfgStyle.palette.variant}";
      };
      ".config/git/ignore".text = lib.strings.concatStringsSep "\n" cfgPrograms.cli.git.ignore;
    };
  };
}
