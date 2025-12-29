{
  config,
  fretboard,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgStyle = cfg.style;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ fretboard.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    nih.user.home.file = {
      ".config/fretboard/config.toml".text = ''
        default_frets = 24
        default_tuning = "Guitar (6) Standard"
        note_format = "sharp"
        theme_name = "catppuccin-${cfgStyle.palette.variant}"
        [[tuning]]
        name = "Guitar (6) Standard"
        data = ["E2", "A2", "D3", "G3", "B3", "E4"]
        [[tuning]]
        name = "Guitar (6) Drop C#"
        data = ["Db2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"]
        [[tuning]]
        name = "Bass (4) Standard"
        frets = 24
        data = ["E1", "A1", "D2", "G2"]
      '';
    };
  };
}
