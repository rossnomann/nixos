{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.gnupg ];
      variables = {
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      };
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
      settings = {
        allow-loopback-pinentry = "";
      };
    };
    home-manager.users.${cfgUser.name}.home.file = {
      ".local/share/gnupg/gpg.conf".text = ''
        no-greeting
        use-agent
        pinentry-mode loopback
      '';
    };
  };
}
