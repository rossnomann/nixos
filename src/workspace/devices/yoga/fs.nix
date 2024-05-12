{ ... }:
{
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
  swapDevices = [
    {
      device = "/var/lib/swap";
      size = 16 * 1024;
    }
  ];
}
