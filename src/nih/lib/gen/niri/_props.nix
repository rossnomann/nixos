lib: kdl:
let
  mk =
    name: primitive: value:
    (lib.mapNullable (x: [
      name
      (primitive x)
    ]) value);
in
{
  mkBool = name: mk name lib.boolToString;
  mkFloat = name: mk name kdl.primitives.mkFloat;
  mkInteger = name: mk name kdl.primitives.mkInteger;
  mkString = name: mk name kdl.primitives.mkString;
  mkStringMap = name: func: mk name (x: kdl.primitives.mkString (func x));
}
