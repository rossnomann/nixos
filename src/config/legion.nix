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
  environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
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
    net.host = "legion";
    power = {
      powertop.enable = false;
      suspend.enable = false;
    };
    programs.cli.git.ignore = [ ".env" ];
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
    graphicalSession = {
      dpi = 144;
      niri.config = {
        outputs = [
          {
            name = "eDP-1";
            mode = "2560x1440@165.003";
            position = {
              x = 0;
              y = 0;
            };
            focusAtStartup = false;
          }
          {
            name = "HDMI-A-1";
            scale = 1.5;
            position = {
              x = 1707;
              y = 0;
            };
            focusAtStartup = true;
          }
        ];
        workspaces = {
          main = {
            openOnOutput = "HDMI-A-1";
            order = 1;
          };
          audio = {
            openOnOutput = "HDMI-A-1";
            order = 2;
          };
          games = {
            openOnOutput = "HDMI-A-1";
            order = 3;
          };
          terminal = {
            openOnOutput = "eDP-1";
            order = 4;
          };
          secondary = {
            openOnOutput = "eDP-1";
            order = 5;
          };
        };
      };
    };
  };
  services = {
    fstrim.enable = true;
    hardware.bolt.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
}
