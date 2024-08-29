{ config, lib, ... }:
let
  cfg = config.nih;
  cfgSync = cfg.sync;
  cfgUser = cfg.user;
in
{
  options.nih.sync = {
    devices = lib.mkOption { type = lib.types.attrs; };
    folders = {
      backup = lib.mkOption { type = lib.types.listOf lib.types.str; };
      books = lib.mkOption { type = lib.types.listOf lib.types.str; };
      documents = lib.mkOption { type = lib.types.listOf lib.types.str; };
      music = lib.mkOption { type = lib.types.listOf lib.types.str; };
      obsidian = lib.mkOption { type = lib.types.listOf lib.types.str; };
      pictures = lib.mkOption { type = lib.types.listOf lib.types.str; };
      exchange = lib.mkOption { type = lib.types.listOf lib.types.str; };
      videos = lib.mkOption { type = lib.types.listOf lib.types.str; };
    };
  };
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      relay.enable = false;
      user = cfgUser.name;
      dataDir = cfgUser.home;
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      systemService = true;
      settings = {
        devices = cfgSync.devices;
        folders = {
          "backup" = {
            enable = true;
            ignorePerms = false;
            label = "Backup";
            path = "${cfgUser.home}/workspace/backup";
            devices = cfgSync.folders.backup;
          };
          "books" = {
            enable = true;
            ignorePerms = false;
            label = "Books";
            path = "${cfgUser.home}/workspace/books";
            devices = cfgSync.folders.books;
          };
          "documents" = {
            enable = true;
            ignorePerms = false;
            label = "Documents";
            path = "${cfgUser.home}/workspace/documents";
            devices = cfgSync.folders.documents;
          };
          "music" = {
            enable = true;
            ignorePerms = false;
            label = "Music";
            path = "${cfgUser.home}/workspace/music";
            devices = cfgSync.folders.music;
          };
          "obsidian" = {
            enable = true;
            ignorePerms = false;
            label = "Obsidian";
            path = "${cfgUser.home}/workspace/obsidian";
            devices = cfgSync.folders.obsidian;
          };
          "pictures" = {
            enable = true;
            label = "Pictures";
            ignorePerms = false;
            path = "${cfgUser.home}/workspace/pictures";
            devices = cfgSync.folders.pictures;
          };
          "exchange" = {
            enable = true;
            label = "Exchange";
            ignorePerms = false;
            path = "${cfgUser.home}/workspace/exchange";
            devices = cfgSync.folders.exchange;
          };
          "videos" = {
            enable = true;
            label = "Videos";
            ignorePerms = false;
            path = "${cfgUser.home}/workspace/videos";
            devices = cfgSync.folders.videos;
          };
        };
        options = {
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          urAccepted = -1;
        };
      };
    };
  };
}
