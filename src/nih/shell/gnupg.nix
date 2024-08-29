{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.gnupg ];
      variables = {
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      };
    };
    nih.user.home.file = {
      ".local/share/gnupg/gpg.conf".source.text = ''
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
  };
}
