{ lib }:
{
  nih = {
    capStr =
      value:
      (lib.strings.concatStrings [
        (lib.strings.toUpper (builtins.substring 0 1 value))
        (builtins.substring 1 (-1) value)
      ]);
  };
}
