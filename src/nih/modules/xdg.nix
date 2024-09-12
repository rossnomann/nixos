{
  config,
  lib,
  ...
}:
let
  cfg = config.nih;
  cfgXdg = cfg.xdg;
in
{
  options.nih.xdg = {
    userDirs = {
      desktop = lib.mkOption { type = lib.types.str; };
      documents = lib.mkOption { type = lib.types.str; };
      download = lib.mkOption { type = lib.types.str; };
      music = lib.mkOption { type = lib.types.str; };
      pictures = lib.mkOption { type = lib.types.str; };
      publicShare = lib.mkOption { type = lib.types.str; };
      templates = lib.mkOption { type = lib.types.str; };
      videos = lib.mkOption { type = lib.types.str; };
    };
    mime = {
      archives = lib.mkOption { type = lib.types.str; };
      audio = lib.mkOption { type = lib.types.str; };
      directories = lib.mkOption { type = lib.types.str; };
      documents = lib.mkOption { type = lib.types.str; };
      images = lib.mkOption { type = lib.types.str; };
      text = lib.mkOption { type = lib.types.str; };
      torrents = lib.mkOption { type = lib.types.str; };
      videos = lib.mkOption { type = lib.types.str; };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=False
      '';
      "xdg/user-dirs.defaults".text = ''
        XDG_DESKTOP_DIR="${cfgXdg.userDirs.desktop}"
        XDG_DOCUMENTS_DIR="${cfgXdg.userDirs.documents}"
        XDG_DOWNLOAD_DIR="${cfgXdg.userDirs.download}"
        XDG_MUSIC_DIR="${cfgXdg.userDirs.music}"
        XDG_PICTURES_DIR="${cfgXdg.userDirs.pictures}"
        XDG_PUBLICSHARE_DIR="${cfgXdg.userDirs.publicShare}"
        XDG_TEMPLATES_DIR="${cfgXdg.userDirs.templates}"
        XDG_VIDEOS_DIR="${cfgXdg.userDirs.videos}"
      '';
    };
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_DESKTOP_DIR = cfgXdg.userDirs.desktop;
      XDG_DOCUMENTS_DIR = cfgXdg.userDirs.documents;
      XDG_DOWNLOAD_DIR = cfgXdg.userDirs.download;
      XDG_MUSIC_DIR = cfgXdg.userDirs.music;
      XDG_PICTURES_DIR = cfgXdg.userDirs.pictures;
      XDG_PUBLICSHARE_DIR = cfgXdg.userDirs.publicShare;
      XDG_TEMPLATES_DIR = cfgXdg.userDirs.templates;
      XDG_VIDEOS_DIR = cfgXdg.userDirs.videos;
    };
    xdg.mime =
      let
        mkAssoc =
          { entry, mimes }:
          builtins.listToAttrs (
            map (v: {
              name = v;
              value = entry;
            }) mimes
          );
        assoc =
          (mkAssoc {
            entry = cfgXdg.mime.archives;
            mimes = lib.nih.mime.types.archives;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.audio;
            mimes = lib.nih.mime.types.audio;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.directories;
            mimes = lib.nih.mime.types.directories;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.documents;
            mimes = lib.nih.mime.types.documents;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.images;
            mimes = lib.nih.mime.types.images;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.text;
            mimes = lib.nih.mime.types.text;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.torrents;
            mimes = lib.nih.mime.types.torrents;
          })
          // (mkAssoc {
            entry = cfgXdg.mime.videos;
            mimes = lib.nih.mime.types.videos;
          });
      in
      {
        enable = true;
        addedAssociations = assoc;
        defaultApplications = assoc;
      };
  };
}
