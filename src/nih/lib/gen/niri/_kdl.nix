lib:
let
  primitives =
    let
      mkString = x: ''"${x}"'';
    in
    {
      inherit mkString;
      mkFloat = builtins.toString;
      mkInteger = builtins.toString;
      mkStringOrNull = x: if x == null then "null" else mkString x;
    };
  mkNode =
    name:
    {
      args ? null,
      props ? null,
      children ? null,
    }:
    {
      inherit
        name
        args
        props
        children
        ;
    };
  mkNodeEmpty = name: mkNode name { };
  mkNodeBool = name: value: if value == true then mkNodeEmpty name else null;
  mkIndent =
    x:
    let
      level = 2;
      indent = lib.strings.replicate level " ";
      indentLine = line: "${indent}${line}";
      lines = lib.strings.splitString "\n" x;
      indentedLines = map indentLine lines;
    in
    lib.strings.concatStringsSep "\n" indentedLines;
  filterList = x: lib.lists.remove null x;
  sanitizeList =
    x:
    let
      result = lib.mapNullable filterList x;
    in
    if result == [ ] then null else result;
  concatLine = x: lib.strings.concatStringsSep " " x;
  concatLines = x: lib.strings.concatStringsSep "\n" x;
  serializeArgs = args: lib.mapNullable concatLine (sanitizeList args);
  serializeProp =
    x:
    let
      name = builtins.elemAt x 0;
      value = builtins.elemAt x 1;
    in
    "${name}=${value}";
  serializeProps =
    props:
    let
      filteredProps = sanitizeList props;
      serializeItems = x: map serializeProp x;
      items = lib.mapNullable serializeItems filteredProps;
    in
    lib.mapNullable serializeArgs items;
  serializeChildren =
    nodes:
    let
      filteredNodes = sanitizeList nodes;
      serializedNodes = lib.mapNullable serialize filteredNodes;
      formatChildren = x: "{\n${mkIndent x}\n}\n";
    in
    lib.mapNullable formatChildren serializedNodes;
  serializeNode =
    node:
    let
      children = serializeChildren node.children;
      result = concatLine (sanitizeList [
        node.name
        (serializeArgs node.args)
        (serializeProps node.props)
        children
      ]);
    in
    if children == null then "${result};" else result;
  serialize = nodes: concatLines (map serializeNode (sanitizeList nodes));
in
{
  inherit
    mkNode
    mkNodeEmpty
    mkNodeBool
    primitives
    serialize
    ;
}
