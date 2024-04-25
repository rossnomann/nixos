{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gnupg ];
  home-manager.users.${config.workspace.user.name} = {
    home.file.".gnupg/gpg.conf".text = ''
      no-greeting
      use-agent
      pinentry-mode loopback
    '';
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
    settings = {
      allow-loopback-pinentry = "";
    };
  };
}
