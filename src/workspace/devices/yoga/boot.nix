{ ... }:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "vmd"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      verbose = false;
    };
    kernelModules = [
      "i915"
      "kvm-intel"
    ];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
}
