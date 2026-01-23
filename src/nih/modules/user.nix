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
  imports = [
    (lib.mkAliasOptionModule
      [
        "nih"
        "user"
        "home"
        "file"
      ]
      [
        "makky"
        "files"
      ]
    )
  ];
  options.nih.user = {
    name = lib.mkOption { type = lib.types.str; };
    description = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
    gpg_signing_key = lib.mkOption { type = lib.types.str; };
    home.root = lib.mkOption { type = lib.types.path; };
  };
  config = lib.mkIf cfg.enable {
    makky = {
      enable = true;
      targetRoot = "$HOME";
      metadataPath = "$HOME/.config/makky.metadata";
    };
    nih.user.home = {
      root = config.users.users.${cfgUser.name}.home;
    };
    nih.user.home.file = {
      ".config/nushell/config.nu".text = ''
        $env.config = {
            show_banner: false
            ls: {
                use_ls_colors: false
                clickable_links: false
            }
            rm: {
                always_trash: true
            }
            datetime_format: {
                normal: '%Y, %B %d, %A %H:%M:%S %:z'
                table: '%d-%m-%Y %H:%M:%S %:z'
            }
            history: {
                # Session has to be reloaded for this to take effect
                max_size: 100_000
                # Enable to share history between multiple sessions, else you have to close the session to write history to file
                sync_on_enter: true
                # "sqlite" or "plaintext"
                file_format: "plaintext"
                # only available with sqlite file_format.
                # true enables history isolation, false disables it.
                # true will allow the history to be isolated to the current session using up/down arrows.
                # false will allow the history to be shared across all sessions.
                isolation: false
            }
            hooks: {
                pre_prompt: [{ ||
                  if (which direnv | is-empty) {
                    return
                  }
                  direnv export json | from json | default {} | load-env
                }]
            }
        }
      '';
      ".config/nushell/env.nu".text = ''
        def create_left_prompt [] {
            let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
            let path_dir = match (do { $env.PWD | path relative-to $nu.home-path }) {
                null => $env.PWD
                ''' => '~'
                $relative_pwd => ([~ $relative_pwd] | path join)
            }
            let path_segment = $"($path_color)($path_dir)"
            let exit_code_color = ansi magenta_bold
            let exit_code_segment = $"($exit_code_color)[ ($env.LAST_EXIT_CODE) ]"
            let time_color = ansi green_bold
            let time_value = (date now | format date '%H:%M:%S')
            let time_segment = $"($time_color)[ ($time_value) ]"
            $"($time_segment) ($path_segment) ($exit_code_segment) "
        }

        $env.PROMPT_COMMAND = {|| create_left_prompt }
        $env.PROMPT_COMMAND_RIGHT = {|| }
      '';
    };
    security.sudo.wheelNeedsPassword = false;
    users.users.${cfgUser.name} = {
      inherit (cfgUser) description;
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.nushell;
    };
  };
}
