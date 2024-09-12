{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
in
{
  options.nih.programs.gnupg = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gnupg;
    };
    executable = lib.mkOption {
      type = lib.types.str;
      default = "${cfgPrograms.gnupg.package}/bin/gpg";
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfgPrograms.gnupg.package ];
      variables = {
        GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      };
    };
    nih.programs.git.gpgProgram = cfgPrograms.gnupg.executable;
    nih.user.home.file = {
      ".local/share/gnupg/gpg.conf".text = ''
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
