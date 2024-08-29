{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgUser = cfg.user;
  nihFilesPackage = config.nih.user.home.files;
in
{
  options.nih.user = {
    name = lib.mkOption { type = lib.types.str; };
    description = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
    gpg_signing_key = lib.mkOption { type = lib.types.str; };
    home = {
      root = lib.mkOption {
        internal = true;
        type = lib.types.path;
      };
      file = lib.mkOption {
        internal = true;
        type = lib.nih.types.file;
      };
      files = lib.mkOption {
        internal = true;
        type = lib.types.package;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ nihFilesPackage ];
    nih.user.home = {
      root = config.users.users.${cfgUser.name}.home;
      files =
        let
          fileConfig = config.nih.user.home.file;
        in
        pkgs.runCommandLocal "nih-files" { } (
          ''
            mkdir -p $out
            nih_reference="$out/nih_reference"
            touch $nih_reference

            function addPath() {
              local source="$1"
              local target="$2"
              echo $source >> $nih_reference
              echo $target >> $nih_reference
            }
          ''
          + lib.strings.concatStrings (
            lib.mapAttrsToList (n: v: ''
              addPath ${
                lib.escapeShellArgs [
                  (builtins.path {
                    path = v.source.path;
                    name = v.storeName;
                  })
                  v.target
                ]
              }
            '') fileConfig
          )
        );
    };
    system.userActivationScripts.nihFiles = ''
      echo "Creating nih links in $HOME"
      function createNihLinks() {
        while read -r source; do
          read -r target
          target=$HOME/$target
          echo "Setting link: $source -> $target"
          mkdir -p "$(dirname "''${target}")"
          if [ -L "''${target}" ] ; then
              rm "''${target}"
              ln -s "''${source}" "''${target}"
              echo "Link replaced"
          elif [ -e "''${target}" ] ; then
              echo "Not a link: $target"
          else
              ln -s "''${source}" "''${target}"
              echo "Link created"
          fi
        done < ${nihFilesPackage}/nih_reference
      }
      createNihLinks
    '';
    users.users.${cfgUser.name} = {
      description = cfgUser.description;
      isNormalUser = true;
    };

    home-manager.users.${cfgUser.name}.home.stateVersion = config.system.stateVersion;
  };
}
