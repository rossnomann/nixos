{ config, ... }:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      verbose = false;
    };
    kernelModules = [
      "kvm-intel"
      "v4l2loopback"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
  };
}
