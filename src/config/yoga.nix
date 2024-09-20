# Lenovo Yoga 7 14ITL5
{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
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
      "v4l2loopback"
    ];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.graphics.enable (lib.mkDefault "va_gl");
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/fbfb4ceb-d9fc-4e0b-b51e-25a6b237cd36";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B55A-71EF";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/77e60d8c-d401-4360-803e-f8c915816f79";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/550bf874-514e-405c-ae6c-7891caa50371";
      fsType = "ext4";
    };
  };
  hardware = {
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
    xserver.videoDrivers = [ "intel" ];
  };
  networking.useDHCP = lib.mkDefault true;
  nih = {
    bluetooth.enable = true;
    net.host = "yoga";
    power = {
      powertop.enable = true;
      suspend.enable = true;
    };
    style = {
      cursors.size = 16;
      fonts =
        let
          defaultSize = 10;
        in
        {
          monospace = {
            inherit defaultSize;
          };
          sansSerif = {
            inherit defaultSize;
          };
          serif = {
            inherit defaultSize;
          };
        };
    };
    sync = {
      devices = {
        "legion" = {
          id = "5GQXKHP-X5MJ7L2-C7LMGQN-KWTUMKB-M6OKG6B-6IO4ASC-Y2ICUKX-U3FDNQN";
          name = "Legion";
          autoAcceptFolders = false;
        };
        "pixel" = {
          id = "NWMRLOG-ZLN76CU-HOOHCNS-5PG7IAO-G7EQMYJ-CNKX6LM-7GXC6YP-2PD7IQT";
          name = "Pixel";
          autoAcceptFolders = false;
        };
      };
      folders = {
        backup = [
          "legion"
          "pixel"
        ];
        books = [
          "legion"
          "pixel"
        ];
        documents = [
          "legion"
          "pixel"
        ];
        music = [ "legion" ];
        obsidian = [
          "legion"
          "pixel"
        ];
        pictures = [
          "legion"
          "pixel"
        ];
        exchange = [ "legion" ];
        videos = [
          "legion"
          "pixel"
        ];
      };
    };
    wayland = {
      enable = true;
      programs.rot8 = {
        enable = true;
        device = "eDP-1";
      };
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swap";
      size = 16 * 1024;
    }
  ];
}
