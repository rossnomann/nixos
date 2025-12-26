{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        obsidianHook = pkgs.writeTextFile {
          name = "obsidian-hook";
          text = ''
            #!${pkgs.python314}/bin/python
            import json
            from pathlib import Path

            PATH = Path("~/.config/obsidian/obsidian.json").expanduser()
            if PATH.exists():
                with PATH.open() as f:
                    data = json.load(f)
                    if isinstance(data, dict) and "vaults" in data:
                        vaults = data["vaults"]
                        for i in vaults.values():
                            i.pop("open", None)
                with PATH.open("w") as f:
                    json.dump(data, f)
          '';
          executable = true;
        };
      in
      [
        pkgs.libreoffice
        (pkgs.obsidian.overrideAttrs (x: {
          postInstall = ''
            sed -i '1 a ${obsidianHook}' $out/bin/obsidian
          '';
        }))
        pkgs.simple-scan
        pkgs.zathura
      ];
    nih.user.home.file = {
      ".config/zathura/zathurarc".text = ''
        include ${cfgSources.catppuccin-zathura}/src/catppuccin-${cfgStyle.palette.variant}
      '';
    };
    nih.graphicalSession.windowRules = [
      {
        appId = ''^libreoffice'';
        workspace = "main";
      }
      {
        appId = ''^obsidian'';
        workspace = "main";
      }
      {
        appId = ''^org\\.pwmt\\.zathura'';
        workspace = "main";
      }
      {
        appId = ''^org\\.gnome\\.SimpleScan'';
        workspace = "main";
      }
    ];
    nih.xdg.mime.documents = "org.pwmt.zathura.desktop";
  };
}
