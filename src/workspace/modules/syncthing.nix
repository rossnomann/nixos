{ config, ... }:
{
  services.syncthing =
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
          "yoga" = {
            id = "6E3M2SX-6XYE4T4-UWRJPWA-V2WADXR-3BZC5SP-EFOAJMO-Z3FK6W6-N56ZXAS";
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
            devices = [ "yoga" ];
          };
          "books" = {
            enable = true;
            ignorePerms = false;
            label = "Books";
            path = "${homeDirectory}/workspace/books";
            devices = [ "yoga" ];
          };
          "documents" = {
            enable = true;
            ignorePerms = false;
            label = "Documents";
            path = "${homeDirectory}/workspace/documents";
            devices = [ "yoga" ];
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
            devices = [ "yoga" ];
          };
          "pictures" = {
            enable = true;
            label = "Pictures";
            ignorePerms = false;
            path = "${homeDirectory}/workspace/pictures";
            devices = [ "yoga" ];
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
            devices = [ "yoga" ];
          };
        };
        options.urAccepted = -1;
      };
    };
}
