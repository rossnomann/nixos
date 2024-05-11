{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.alsa-utils ];
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
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
    printing = {
      enable = true;
      cups-pdf.enable = true;
    };
    saned.enable = true;
    thermald.enable = true;
    tlp.enable = true;
  };
}
