{ palette, wm }:
let
  gutterSize = builtins.toString wm.gutterSize;
  marginSize = builtins.toString wm.marginSize;
in
''
  #![enable(implicit_some)]
  (
      border_width: 1,
      default_border_color: "${palette.overlay2}",
      floating_border_color: "${palette.overlay1}",
      focused_border_color: "${palette.green}",
      margin: ${marginSize},
      workpace_magin: 0,
      gutter: [
          (side: Top, value: ${gutterSize},),
          (side: Right, value: ${gutterSize},),
          (side: Bottom, value: ${gutterSize},),
          (side: Left, value: ${gutterSize},),
      ],
  )
''
