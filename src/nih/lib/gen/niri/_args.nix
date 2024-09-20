lib: kdl:
let
  mk =
    primitive: name: value:
    (lib.mapNullable (x: kdl.mkNode name { args = [ (primitive x) ]; }) value);
in
{
  mkBool = mk lib.boolToString;
  mkFloat = mk kdl.primitives.mkFloat;
  mkIdent = mk lib.id;
  mkInteger = mk kdl.primitives.mkInteger;
  mkString = mk kdl.primitives.mkString;
  mkStringOrNull = name: value: kdl.mkNode name { args = [ (kdl.primitives.mkStringOrNull value) ]; };
}
