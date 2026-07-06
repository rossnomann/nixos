palette: ''
  theme = "catppuccin_${palette.variant}"
  [editor]
  auto-format = true
  clipboard-provider = "wayland"
  continue-comments = false
  cursorcolumn = false
  cursorline = false
  gutters = [ "line-numbers", "spacer", "diagnostics", "spacer", "diff", "spacer" ]
  line-number = "relative"
  trim-final-newlines = true
  trim-trailing-whitespace = true
  true-color = true
  [editor.cursor-shape]
  normal = "block"
  insert = "bar"
  select = "underline"
  [editor.file-picker]
  hidden = false
  [editor.indent-guides]
  render = true
  skip-levels = 1
  [editor.inline-diagnostics]
  cursor-line = "info"
  other-lines = "info"
  prefix-len = 3
  [editor.lsp]
  display-progress-messages = true
  [editor.smart-tab]
  enable = false
  [editor.soft-wrap]
  enable = true
  [editor.statusline]
  left = [ "version-control", "mode", "file-type", "read-only-indicator", "file-modification-indicator", "file-name" ]
  center = [ "selections", "register", "diagnostics" ]
  right = [ "position", "total-line-numbers", "file-indent-style", "file-encoding", "file-line-ending" ]
  mode.normal = "N"
  mode.insert = "I"
  mode.select = "S"
  [editor.whitespace.render]
  tab = "all"
''
