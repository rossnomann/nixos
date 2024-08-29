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
      ".config/macchina/macchina.toml".source.text = ''
        # Toggle between displaying the current shell or your user's default one.
        current_shell = true

        # Lengthen kernel output
        long_kernel = true

        # Lengthen shell output
        long_shell = false

        # Lengthen uptime output
        long_uptime = false

        # Toggle between displaying the number of physical or logical cores of your processor.
        physical_cores = true

        # Themes need to be placed in "$XDG_CONFIG_DIR/macchina/themes" beforehand.
        theme = "default"

        # Displays only the specified readouts.
        show = [
            "Battery",
            "Backlight",
            "Host",
            "Kernel",
            "Memory",
            "Processor",
            "ProcessorLoad",
            "Uptime",
        ]
      '';
      ".config/macchina/themes/default.toml".source.text = ''
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
        visible = false

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
