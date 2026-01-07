{ themePath, fontMonospace }:
''
  [general]
  import = ["${themePath}"]
  [cursor.style]
  blinking = "Always"
  shape = "Beam"
  [font]
  size = ${toString fontMonospace.defaultSize}
  [font.normal]
  family = "${fontMonospace.family}"
  [scrolling]
  history = 100000
  [window]
  decorations = "None"
  [window.padding]
  x = 20
  y = 10
''
