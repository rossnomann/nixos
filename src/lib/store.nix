{ lib, writeTextFile }:
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
  mkStoreFileName =
    prefix: value:
    let
      unsafeString = lib.strings.replaceStrings safeCharactersList replacementSafeCharactersList value;
      unsafeCharactersList = lib.strings.stringToCharacters unsafeString;
      replacementUnsafeCharactersList = mkReplacementCharactersList unsafeCharactersList;
      result = lib.strings.replaceStrings unsafeCharactersList replacementUnsafeCharactersList value;
    in
    prefix + result;
in
{
  writeFile =
    {
      name,
      text,
      executable,
    }:
    writeTextFile {
      name = (mkStoreFileName "nih_" name);
      inherit executable text;
    };
}
