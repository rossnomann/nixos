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
  format.pretty = "fuller";
  pull.ff = "only";
  init.defaultBranch = "master";
  include.path = "${cfgSources.catppuccin-delta}/catppuccin.gitconfig";
  log.showSignature = true;
  delta = {
    features = "catppuccin-${cfgStyle.palette.variant}";
    hyperlinks = true;
    line-numbers = true;
    navigate = true;
    relative-paths = true;
    side-by-side = true;
  };
  merge.conflictStyle = "zdiff3";
}
