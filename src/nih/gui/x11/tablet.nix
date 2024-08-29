{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgGui = cfg.gui;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf (cfg.enable && cfgGui.x11.tablet.enable) {
    environment = {
      systemPackages = [
        pkgs.onboard
        pkgs.rot8
        pkgs.xf86_input_wacom
      ];
      variables = {
        MOZ_USE_XINPUT2 = "1";
      };
    };
    services.xserver.serverFlagsSection = ''
      Option "RandRRotation" "on"
    '';
    home-manager.users.${cfgUser.name}.home.file = {
      ".config/systemd/user/rot8.service".text = ''
        [Install]
        WantedBy=leftwm-session.target
        [Service]
        ExecStart=${pkgs.rot8}/bin/rot8 -d eDP1 --touchscreen 'Wacom HID 5250 Finger'
        PassEnvironment=DISPLAY
        PassEnvironment=PATH
        [Unit]
        After=leftwm-session.target
        Description=Automatic display rotation
      '';
    };
  };
}
