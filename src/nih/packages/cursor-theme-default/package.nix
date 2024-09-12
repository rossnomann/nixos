{ inherits, writeTextFile }:
writeTextFile {
  name = "index.theme";
  destination = "/share/icons/default/index.theme";
  # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
  text = ''
    [Icon Theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=${inherits}
  '';
}
