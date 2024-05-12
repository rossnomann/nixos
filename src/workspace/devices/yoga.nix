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
    kernelModules = [
      "i915"
      "kvm-intel"
    ];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
  environment = {
    systemPackages = [ pkgs.powertop pkgs.xf86_input_wacom ];
    variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };
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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Experimental = true;
      };
    };
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.intel-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
    };
  };
  powerManagement.powertop.enable = true;
  services = {
    autorandr =
      let
        dpi = config.workspace.ui.dpi;
      in
      {
        enable = true;
        hooks = {
          postswitch = {
            "dpi" = ''
              xrandr --dpi ${builtins.toString dpi}
              leftwm command SoftReload
            '';
          };
        };
        ignoreLid = true;
        profiles = {
          default = {
            fingerprint = {
              "eDP1" = "00ffffffffffff0009e5550800000000331c0104a51f117802ff35a756509f270e505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e36350a0086";
            };
            config = {
              "eDP1" = {
                crtc = 0;
                inherit dpi;
                mode = "1920x1080";
                position = "0x0";
                rate = "60.00";
              };
            };
          };
        };
      };
    fstrim.enable = true;
    hardware.bolt.enable = true;
    logind.lidSwitch = "ignore";
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
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  workspace.ui = {
    cursorTheme.size = 14;
    dpi = 144;
    font =
      let
        defaultSize = 8;
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
    wm = {
      gutterSize = 6;
      marginSize = 3;
    };
  };
}
