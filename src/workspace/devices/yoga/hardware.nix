{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General.Experimental = true;
      };
    };
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.intel-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
    };
  };
  services = {
    fstrim.enable = true;
    hardware.bolt.enable = true;
    xserver = {
      serverFlagsSection = ''
        Option "RandRRotation" "on"
      '';
      videoDrivers = [ "intel" ];
    };
  };
}
