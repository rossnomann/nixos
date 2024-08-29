{
  config,
  lib,
  npins,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.delta
      pkgs.git
    ];
    nih.user.home.file = {
      ".config/git/config".source.text = ''
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
        features = catppuccin-${cfgPalette.variant}
      '';
      ".config/git/ignore".source.text = ''
        .direnv
        .envrc
      '';
    };
  };
}
