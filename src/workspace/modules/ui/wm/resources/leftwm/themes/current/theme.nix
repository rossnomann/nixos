{ palette }:
''
  #![enable(implicit_some)]
  (
      border_width: 1,
      default_border_color: "${palette.overlay2}",
      floating_border_color: "${palette.overlay1}",
      focused_border_color: "${palette.green}",
      margin: 6,
      workpace_magin: 0,
      gutter: [
          (side: Top, value: 12,),
          (side: Right, value: 12,),
          (side: Bottom, value: 12,),
          (side: Left, value: 12,),
      ],
  )
''
