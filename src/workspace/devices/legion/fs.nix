{ ... }:
{
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
}
