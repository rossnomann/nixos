{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.delta
      pkgs.git
    ];
    nih.user.home.file = {
      ".config/git/config".text = ''
        [user]
        email = ${cfgUser.email}
        name = ${cfgUser.description}
        signingkey = ${cfgUser.gpg_signing_key}
        [core]
        autocrlf = input
        editor = nano
        excludesfile = ~/.config/git/ignore
        pager = delta --dark
        [alias]
        st = status
        ci = commit
        [gpg]
        program = gpg2
        [pull]
        ff = only
        [init]
        defaultBranch = master
        [include]
        path = ${npins.catppuccin-delta}/catppuccin.gitconfig
        [delta]
        features = catppuccin-${cfgStyle.palette.variant}
      '';
      ".config/git/ignore".text = ''
        .direnv
        .envrc
      '';
    };
  };
}
