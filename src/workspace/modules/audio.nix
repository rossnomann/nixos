{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.alsa-utils ];
  services.pipewire = {
    alsa = {
      enable = true;
      support32Bit = true;
    };
    audio.enable = true;
    enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
