# Lenovo Yoga 7 14ITL5
{
  config,
  lib,
  pkgs,
  ...
}:
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
    kernelModules = [ "kvm-intel" ];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
  environment.systemPackages = [ pkgs.blueman ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/fbfb4ceb-d9fc-4e0b-b51e-25a6b237cd36";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B55A-71EF";
      fsType = "vfat";
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
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  services = {
    hardware.bolt.enable = true;
    fstrim.enable = true;
    syncthing =
      let
        user = config.workspace.user.name;
        homeDirectory = config.home-manager.users.${user}.home.homeDirectory;
      in
      {
        enable = true;
        relay.enable = false;
        user = user;
        dataDir = homeDirectory;
        guiAddress = "127.0.0.1:8384";
        openDefaultPorts = true;
        overrideDevices = true;
        overrideFolders = true;
        systemService = true;
        settings = {
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
            "backup" = {
              enable = true;
              ignorePerms = false;
              label = "Backup";
              path = "${homeDirectory}/workspace/backup";
              devices = [
                "legion"
                "pixel"
              ];
            };
            "books" = {
              enable = true;
              ignorePerms = false;
              label = "Books";
              path = "${homeDirectory}/workspace/books";
              devices = [
                "legion"
                "pixel"
              ];
            };
            "documents" = {
              enable = true;
              ignorePerms = false;
              label = "Documents";
              path = "${homeDirectory}/workspace/documents";
              devices = [
                "legion"
                "pixel"
              ];
            };
            "music" = {
              enable = true;
              ignorePerms = false;
              label = "Music";
              path = "${homeDirectory}/workspace/music";
              devices = [ "legion" ];
            };
            "obsidian" = {
              enable = true;
              ignorePerms = false;
              label = "Obsidian";
              path = "${homeDirectory}/workspace/obsidian";
              devices = [
                "legion"
                "pixel"
              ];
            };
            "pictures" = {
              enable = true;
              label = "Pictures";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/pictures";
              devices = [
                "legion"
                "pixel"
              ];
            };
            "exchange" = {
              enable = true;
              label = "Exchange";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/exchange";
              devices = [ "legion" ];
            };
            "videos" = {
              enable = true;
              label = "Videos";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/videos";
              devices = [
                "legion"
                "pixel"
              ];
            };
          };
          options = {
            globalAnnounceEnabled = false;
            relaysEnabled = false;
            urAccepted = -1;
          };
        };
      };
    xserver.videoDrivers = [ "intel" ];
  };
}
