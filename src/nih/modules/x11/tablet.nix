{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgX11 = cfg.x11;
in
{
  config = lib.mkIf (cfg.enable && cfgX11.enable && cfgX11.tablet.enable) {
    environment.systemPackages = [
      pkgs.onboard
      pkgs.rot8
      pkgs.xf86_input_wacom
    ];
    environment.variables = {
      MOZ_USE_XINPUT2 = "1";
    };
    nih.user.home.file = {
      ".config/systemd/user/rot8.service".text = ''
        [Install]
        WantedBy=wm-session.target
        [Service]
        ExecStart=${pkgs.rot8}/bin/rot8 -d eDP1 --touchscreen 'Wacom HID 5250 Finger'
        PassEnvironment=DISPLAY
        PassEnvironment=PATH
        [Unit]
        After=wm-session.target
        Description=Automatic display rotation
      '';
    };
    nih.x11.wm.windowRules = [
      {
        windowClass = "onboard";
        spawnAsType = "Normal";
        spawnFloating = true;
        spawnSticky = true;
      }
    ];
    services.xserver.serverFlagsSection = ''
      Option "RandRRotation" "on"
    '';
  };
}
