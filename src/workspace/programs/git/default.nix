{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.git
    pkgs.delta
  ];
  home-manager.users.${config.workspace.user.name}.xdg.configFile =
    let
      user = config.workspace.user;
    in
    {
      "git/config".text = ''
        [user]
        email = ${user.email}
        name = ${user.description}
        signingkey = ${user.gpg_signing_key}
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
        path = ~/.config/git/delta
      '';
      "git/delta".source = ./resources/delta;
      "git/ignore".source = ./resources/ignore;
    };
}
