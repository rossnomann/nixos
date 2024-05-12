{ config, pkgs, ... }:
{
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
  home-manager.users.${config.workspace.user.name}.systemd.user.services.rot8 = {
    Unit = {
      After = [ "leftwm-session.target" ];
      Description = "Automatic display rotation";
    };
    Service = {
      PassEnvironment = [
        "DISPLAY"
        "PATH"
      ];
      ExecStart = "${pkgs.rot8}/bin/rot8 -d eDP1 --touchscreen 'Wacom HID 5250 Finger'";
    };
    Install = {
      WantedBy = [ "leftwm-session.target" ];
    };
  };
}
