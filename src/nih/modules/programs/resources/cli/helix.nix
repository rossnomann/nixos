palette: ''
  theme = "catppuccin_${palette.variant}"
  [editor]
  clipboard-provider = "wayland"
  cursorline = true
  gutters = [ "line-numbers", "spacer", "diagnostics", "spacer", "diff", "spacer" ]
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
