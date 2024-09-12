let
  mkGtk2Settings =
    {
      cursorThemeName,
      cursorThemeSize,
      fontName,
      iconThemeName,
      themeName,
    }:
    ''
      gtk-cursor-theme-name = "${cursorThemeName}"
      gtk-cursor-theme-size = ${builtins.toString cursorThemeSize}
      gtk-font-name = "${fontName}"
      gtk-icon-theme-name = "${iconThemeName}"
      gtk-theme-name = "${themeName}"
    '';
  mkGtk3And4Settings =
    {
      cursorThemeName,
      cursorThemeSize,
      decorationLayout,
      fontName,
      iconThemeName,
      themeName,
    }:
    ''
      [Settings]
      gtk-cursor-theme-name=${cursorThemeName}
      gtk-cursor-theme-size=${builtins.toString cursorThemeSize}
      gtk-decoration-layout=${decorationLayout}
      gtk-font-name=${fontName}
      gtk-icon-theme-name=${iconThemeName}
      gtk-theme-name=${themeName}
    '';
in
{
  inherit mkGtk2Settings;
  mkGtk3Settings = mkGtk3And4Settings;
  mkGtk4Settings = mkGtk3And4Settings;
}
