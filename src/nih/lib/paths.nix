{ lib }:
{
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
}
