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
  options.nih.programs.cli.gnupg = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.cli.gnupg.package ];
    environment.variables.GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    nih.programs.cli.git.gpgProgram = cfgPrograms.cli.gnupg.executable;
    nih.programs.cli.gnupg.executable = "${cfgPrograms.cli.gnupg.package}/bin/gpg";
    nih.programs.cli.gnupg.package = pkgs.gnupg;
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
