{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.macchina ];
    nih.user.home.file = {
      ".config/macchina/macchina.toml".text =
        let
          show = [
            "Battery"
            "Backlight"
            "Host"
            "Kernel"
            "Memory"
            "Processor"
            "ProcessorLoad"
            "Uptime"
          ];
        in
        ''
          current_shell = true
          long_kernel = true
          long_shell = false
          long_uptime = false
          physical_cores = true
          theme = "default"
          show = [${lib.concatStringsSep ", " (map (x: ''"${x}"'') show)}]
        '';
      ".config/macchina/themes/default.toml".text = ''
        key_color = "Green"
        hide_ascii = true
        padding = 2
        separator = ":"
        separator_color = "White"
        spacing = 2

        [palette]
        type = "Full"
        visible = false

        [bar]
        glyph = "ߋ"
        hide_delimiters = true
        symbol_open = '['
        symbol_close = ']'
        visible = true

        [box]
        visible = true

        [box.inner_margin]
        x = 0
        y = 0

        [randomize]
        key_color = false
        separator_color = false
      '';
    };
  };
}
