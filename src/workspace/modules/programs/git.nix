{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.git
    pkgs.delta
  ];
  workspace.home.xdg.configFile =
    let
      user = config.workspace.user;
    in
    {
      "git/config".text = ''
        [user]
        email = ${user.email}
        name = ${user.description}
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
      '';
      "git/ignore".text = ''
        .envrc
      '';
    };
}
