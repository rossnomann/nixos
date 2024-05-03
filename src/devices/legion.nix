# Lenovo Legion 5 15IAH7H
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
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      verbose = false;
    };
    kernelModules = [ "kvm-intel" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
  };
  environment.systemPackages = [ pkgs.blueman ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/74befeea-8d73-49e7-a803-e12cd7154a68";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6299-4FAF";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/c86adc1b-f716-4a9b-933d-9c3461e03903";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/3485cfa5-a9ad-4d89-a104-75f7c1b6dec1";
      fsType = "ext4";
    };
  };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  services = {
    autorandr = {
      enable = true;
      hooks = {
        postswitch = {
          "dpi" = ''
            xrandr --dpi 144
            leftwm command SoftReload
          '';
        };
      };
      ignoreLid = true;
      profiles = {
        "desktop" = {
          fingerprint = {
            "DP-4" = "00ffffffffffff000e6f091500000000001f0104a522137803da45a4544b9b260f505400000001010101010101010101010101010101636300a0a0a077503020350058c110000018000000fd0c3ca5020246010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e463630314341312d330a20019c701379000003011450110184ff099f002f001f009f0576000200040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006190";
            "HDMI-0" = "00ffffffffffff00220e6f3601010101091f010380351e782a0e35a4544d9d260f5054a10800d1c081c081809500a9c0a940b300d100565e00a0a0a02950302035000f282100001a000000fd00323c1e5a19000a202020202020000000fc0048502032346d710a2020202020000000ff00434e43313039313851340a20200195020319b149101f0413031202110167030c0010000032e2006b023a801871382d40582c45000f282100001e023a80d072382d40102c45800f282100001e565e00a0a0a02950302035000f282100001a283c80a070b02340302036000f282100001a0000000000000000000000000000000000000000000000000000000000002e";
          };
          config = {
            "HDMI-0" = {
              crtc = 0;
              dpi = 144;
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              primary = true;
              rate = "59.95";
            };
            "DP-4" = {
              crtc = 1;
              dpi = 144;
              enable = true;
              mode = "2560x1440";
              position = "0x1440";
              rate = "165.00";
            };
          };
        };
        "mobile" = {
          fingerprint = {
            "DP-4" = "00ffffffffffff000e6f091500000000001f0104a522137803da45a4544b9b260f505400000001010101010101010101010101010101636300a0a0a077503020350058c110000018000000fd0c3ca5020246010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e463630314341312d330a20019c701379000003011450110184ff099f002f001f009f0576000200040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006190";
          };
          config = {
            "DP-4" = {
              crtc = 0;
              mode = "2560x1440";
              position = "0x0";
              rate = "165.00";
            };
          };
        };
      };
    };
    hardware.bolt.enable = true;
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
            "pixel" = {
              id = "NWMRLOG-ZLN76CU-HOOHCNS-5PG7IAO-G7EQMYJ-CNKX6LM-7GXC6YP-2PD7IQT";
              name = "Pixel";
              autoAcceptFolders = false;
            };
            "yoga" = {
              id = "KLZAHUM-6HCYKBW-UVKYQSM-L5PMTUN-W6UHD5R-M5VZIRC-2JGZ3OM-AYPP2QO";
              name = "Yoga";
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
                "pixel"
                "yoga"
              ];
            };
            "books" = {
              enable = true;
              ignorePerms = false;
              label = "Books";
              path = "${homeDirectory}/workspace/books";
              devices = [
                "pixel"
                "yoga"
              ];
            };
            "documents" = {
              enable = true;
              ignorePerms = false;
              label = "Documents";
              path = "${homeDirectory}/workspace/documents";
              devices = [
                "pixel"
                "yoga"
              ];
            };
            "music" = {
              enable = true;
              ignorePerms = false;
              label = "Music";
              path = "${homeDirectory}/workspace/music";
              devices = [ "yoga" ];
            };
            "obsidian" = {
              enable = true;
              ignorePerms = false;
              label = "Obsidian";
              path = "${homeDirectory}/workspace/obsidian";
              devices = [
                "pixel"
                "yoga"
              ];
            };
            "pictures" = {
              enable = true;
              label = "Pictures";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/pictures";
              devices = [
                "pixel"
                "yoga"
              ];
            };
            "exchange" = {
              enable = true;
              label = "Exchange";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/exchange";
              devices = [ "yoga" ];
            };
            "videos" = {
              enable = true;
              label = "Videos";
              ignorePerms = false;
              path = "${homeDirectory}/workspace/videos";
              devices = [
                "pixel"
                "yoga"
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
    xserver.videoDrivers = [ "nvidia" ];
  };
}
