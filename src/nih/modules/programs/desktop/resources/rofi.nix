fontSize: ''
  @import "palette"
  @import "theme"

  configuration {
    click-to-exit: true;
    combi-hide-mode-prefix: true;
    display-combi: ">>>";
    drun-show-actions: true;
    fixed-num-lines: true;
    font: "mono ${toString fontSize}";
    location: 0;
    modes: "combi,window,drun";
    show-icons: false;
    steal-focus: true;
  }
''
