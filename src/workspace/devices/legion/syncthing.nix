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
    };
  };
}
