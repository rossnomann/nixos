lib: {
  mkIconPath =
    let
      iconsCategories = [
        "actions"
        "animations"
        "apps"
        "categories"
        "devices"
        "emblems"
        "emotes"
        "filesystem"
        "intl"
        "legacy"
        "mimetypes"
        "places"
        "status"
        "stock"
      ];
    in
    {
      themePackage,
      themeName,
      iconsSize,
    }:
    lib.concatStringsSep ":" (
      map (
        iconsCategory: "${themePackage}/share/icons/${themeName}/${iconsSize}/${iconsCategory}"
      ) iconsCategories
    );
  mkConfig =
    {
      background,
      follow,
      font,
      foreground,
      frameColor,
      frameColorCritical,
      frameColorLow,
      frameWidth,
      gapSize,
      iconPath,
      offsetX,
      offsetY,
      origin,
    }:
    ''
      [global]
      background="${background}"
      follow="${follow}"
      font="${font}"
      foreground="${foreground}"
      frame_color="${frameColor}"
      frame_width=${builtins.toString frameWidth}
      gap_size=${builtins.toString gapSize}
      offset="(${builtins.toString offsetX}, ${builtins.toString offsetY})"
      origin="${origin}"
      icon_path="${iconPath}"
      [urgency_critical]
      frame_color="${frameColorCritical}"
      [urgency_low]
      frame_color="${frameColorLow}"
    '';
}
