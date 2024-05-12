{ config, ... }:
let
  user = config.workspace.user.name;
  homeDirectory = config.home-manager.users.${user}.home.homeDirectory;
in
{
  services.syncthing = {
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
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        urAccepted = -1;
      };
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
    };
  };
}
