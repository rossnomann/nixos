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
  mkStoreFileName =
    let
      safeCharactersList =
        [
          "+"
          "."
          "_"
          "?"
          "="
        ]
        ++ lib.strings.lowerChars ++ lib.strings.upperChars ++ lib.strings.stringToCharacters "0123456789";
      mkReplacementCharactersList = l: lib.genList (x: "") (lib.length l);
      replacementSafeCharactersList = mkReplacementCharactersList safeCharactersList;
    in
    prefix: value:
    let
      unsafeString = lib.strings.replaceStrings safeCharactersList replacementSafeCharactersList value;
      unsafeCharactersList = lib.strings.stringToCharacters unsafeString;
      replacementUnsafeCharactersList = mkReplacementCharactersList unsafeCharactersList;
      result = lib.strings.replaceStrings unsafeCharactersList replacementUnsafeCharactersList value;
    in
    prefix + result;
}
