# Lenovo Legion 5 15IAH7H
{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    blacklistedKernelModules = [ "nova_core" ];
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
    kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    kernelParams = [
      "i8042.nopnp=1"
      "pcie_aspm=off"
      "pcie_port_pm=off"
    ];
    kernelModules = [
      "kvm-intel"
      "v4l2loopback"
    ];
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/74befeea-8d73-49e7-a803-e12cd7154a68";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6299-4FAF";
      fsType = "vfat";
      options = [ "umask=0077" ];
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
  environment.variables = {
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
  };
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      # Dynamic Boost balances power between the CPU and the GPU
      # for improved performance on supported laptops using the nvidia-powerd daemon.
      # https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/dynamicboost.html
      dynamicBoost.enable = true;

      modesetting.enable = true;

      # Nvidia power management.
      # Experimental
      # https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/powermanagement.html
      # Fine-grained power management turns off GPU when not in use.
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # It is suggested to use the open source kernel modules on Turing or later GPUs (RTX series, GTX 16xx),
      # and the closed source modules otherwise.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
  networking.useDHCP = lib.mkDefault true;
  nih = {
    bluetooth.enable = true;
    net.host = "legion";
    power = {
      powertop.enable = false;
      suspend.enable = false;
    };
    programs = {
      audio = {
        ardour.enable = true;
        plugins = {
          lv2.enable = true;
        };
        vamp.enable = true;
      };
      cli.git.ignore = [ ".env" ];
      games.enable = true;
      graphics = {
        gimp.enable = true;
        inkscape.enable = true;
      };
      im = {
        discord.enable = true;
        slack.enable = true;
      };
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
        "yoga" = {
          id = "CLCF7RW-LFQQ6VG-ET5OAQX-ASAT3VT-3WRNRBP-WRZYDQM-VG6KYXI-TG4JAAP";
          name = "Yoga";
          autoAcceptFolders = false;
        };
      };
      folders = {
        backup = [ "yoga" ];
        books = [ "yoga" ];
        documents = [ "yoga" ];
        music = [ "yoga" ];
        obsidian = [ "yoga" ];
        pictures = [ "yoga" ];
        exchange = [ "yoga" ];
        videos = [ "yoga" ];
      };
    };
    x11 =
      let
        dpi = 144;
      in
      {

        inherit dpi;
        enable = true;
        autorandr.profiles = {
          "desktop" = {
            fingerprint = {
              "DP-4" =
                "00ffffffffffff000e6f091500000000001f0104a522137803da45a4544b9b260f505400000001010101010101010101010101010101636300a0a0a077503020350058c110000018000000fd0c3ca5020246010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e463630314341312d330a20019c701379000003011450110184ff099f002f001f009f0576000200040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006190";
              "HDMI-0" =
                "00ffffffffffff00220e6f3601010101091f010380351e782a0e35a4544d9d260f5054a10800d1c081c081809500a9c0a940b300d100565e00a0a0a02950302035000f282100001a000000fd00323c1e5a19000a202020202020000000fc0048502032346d710a2020202020000000ff00434e43313039313851340a20200195020319b149101f0413031202110167030c0010000032e2006b023a801871382d40582c45000f282100001e023a80d072382d40102c45800f282100001e565e00a0a0a02950302035000f282100001a283c80a070b02340302036000f282100001a0000000000000000000000000000000000000000000000000000000000002e";
            };
            config = {
              "HDMI-0" = {
                crtc = 0;
                inherit dpi;
                enable = true;
                mode = "2560x1440";
                position = "2560x0";
                primary = true;
                rate = "59.95";
              };
              "DP-4" = {
                crtc = 1;
                inherit dpi;
                enable = true;
                mode = "2560x1440";
                position = "0x0";
                rate = "165.00";
              };
            };
          };
          "mobile" = {
            fingerprint = {
              "DP-4" =
                "00ffffffffffff000e6f091500000000001f0104a522137803da45a4544b9b260f505400000001010101010101010101010101010101636300a0a0a077503020350058c110000018000000fd0c3ca5020246010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e463630314341312d330a20019c701379000003011450110184ff099f002f001f009f0576000200040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006190";
            };
            config = {
              "DP-4" = {
                crtc = 0;
                inherit dpi;
                mode = "2560x1440";
                position = "0x0";
                rate = "165.00";
              };
            };
          };
        };
        wm = {
          gutterSize = 0;
          marginSize = 1;
        };
      };
  };
  services = {
    fstrim.enable = true;
    hardware.bolt.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
}
