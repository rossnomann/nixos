{
  lib,
  cfgSources,
  cfgStyle,
  cfgUser,
  editor,
  gpg,
  pager,
}:
lib.generators.toGitINI {
  user = {
    inherit (cfgUser) email;
    name = cfgUser.description;
    signingkey = cfgUser.gpg_signing_key;
  };
  core = {
    inherit editor pager;
    autocrlf = "input";
    excludesfile = "~/.config/git/ignore";
  };
  alias = {
    st = "status";
    ci = "commit";
  };
  gpg.program = gpg;
  pull.ff = "only";
  init.defaultBranch = "master";
  include.path = "${cfgSources.catppuccin-delta}/catppuccin.gitconfig";
  delta.features = "catppuccin-${cfgStyle.palette.variant}";
}
