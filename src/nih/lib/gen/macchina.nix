lib: {
  /**
    Make macchina configuration file

    # Inputs

    `currentShell`

    : Toggle between displaying the current shell or your user's default one.

    `longKernel`

    : Lengthen kernel output

    `longShell`

    : Lengthen shell output

    `longUptime`

    : Lengthen uptime output

    `physicalCores`

    : Toggle between displaying the number of physical or logical cores of your processor.

    `theme`

    : Themes need to be placed in "$XDG_CONFIG_DIR/macchina/themes" beforehand.

    `show`

    : Displays only the specified readouts.
  */
  mkConfig =
    {
      currentShell ? true,
      longKernel ? true,
      longShell ? false,
      longUptime ? false,
      physicalCores ? true,
      theme ? "default",
      show ? [
        "Battery"
        "Backlight"
        "Host"
        "Kernel"
        "Memory"
        "Processor"
        "ProcessorLoad"
        "Uptime"
      ],
    }:
    ''
      current_shell = ${lib.boolToString currentShell}
      long_kernel = ${lib.boolToString longKernel}
      long_shell = ${lib.boolToString longShell}
      long_uptime = ${lib.boolToString longUptime}
      physical_cores = ${lib.boolToString physicalCores}
      theme = "${theme}"
      show = [${lib.concatStringsSep ", " (map (x: ''"${x}"'') show)}]
    '';
  mkTheme =
    {
      keyColor ? "Green",
      hideAscii ? true,
      padding ? 2,
      separator ? ":",
      separatorColor ? "White",
      spacing ? 2,
      paletteType ? "Full",
      paletteVisible ? false,
      barGlyph ? "ߋ",
      barHideDelimiters ? true,
      barSymbolOpen ? "[",
      barSymbolClose ? "]",
      barVisible ? true,
      boxVisible ? false,
      boxInnerMarginX ? 0,
      boxInnerMarginY ? 0,
      randomizeKeyColor ? false,
      randomizeSeparatorColor ? false,
    }:
    ''
      key_color = "${keyColor}"
      hide_ascii = ${lib.boolToString hideAscii}
      padding = ${builtins.toString padding}
      separator = "${separator}"
      separator_color = "${separatorColor}"
      spacing = ${builtins.toString spacing}

      [palette]
      type = "${paletteType}"
      visible = ${lib.boolToString paletteVisible}

      [bar]
      glyph = "${barGlyph}"
      hide_delimiters = ${lib.boolToString barHideDelimiters}
      symbol_open = '${barSymbolOpen}'
      symbol_close = '${barSymbolClose}'
      visible = ${lib.boolToString barVisible}

      [box]
      visible = ${lib.boolToString boxVisible}

      [box.inner_margin]
      x = ${builtins.toString boxInnerMarginX}
      y = ${builtins.toString boxInnerMarginY}

      [randomize]
      key_color = ${lib.boolToString randomizeKeyColor}
      separator_color = ${lib.boolToString randomizeSeparatorColor}
    '';
}
