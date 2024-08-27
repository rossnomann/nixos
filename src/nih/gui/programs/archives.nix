{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.unrar
      pkgs.xarchiver
    ];
    home-manager.users.${cfgUser.name} = {
      xdg.mimeApps =
        let
          entries = [ "xarchiver.desktop" ];
          assoc = (
            builtins.listToAttrs (
              (map
                (v: {
                  name = v;
                  value = entries;
                })
                [
                  "application/gzip"
                  "application/java-archive"
                  "application/vnd.debian.binary-package"
                  "application/vnd.rar"
                  "application/vnd.snap"
                  "application/vnd.squashfs"
                  "application/x-7z-compressed"
                  "application/x-archive"
                  "application/x-arj"
                  "application/x-bzip"
                  "application/x-bzip-compressed-tar"
                  "application/x-bzip1"
                  "application/x-bzip1-compressed-tar"
                  "application/x-bzip2"
                  "application/x-bzip2-compressed-tar"
                  "application/x-bzip3"
                  "application/x-bzip3-compressed-tar"
                  "application/x-compressed-tar"
                  "application/x-lzma"
                  "application/x-lzma-compressed-tar"
                  "application/x-rar"
                  "application/x-tar"
                  "application/x-tarz"
                  "application/x-xz"
                  "application/x-xz-compressed-tar"
                  "application/x-zstd-compressed-tar"
                  "application/zip"
                  "application/zstd"
                ]
              )
            )
          );
        in
        {
          associations.added = assoc;
          defaultApplications = assoc;
        };
    };
  };
}
