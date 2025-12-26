lib:
let
  indentNodes =
    x:
    let
      level = 2;
      indent = lib.strings.replicate level " ";
      indentLine = line: "${indent}${line}";
      lines = lib.strings.splitString "\n" x;
      indentedLines = map indentLine lines;
    in
    lib.strings.concatStringsSep "\n" indentedLines;
  removeNull = x: lib.lists.remove null x;
  sanitizeList =
    x:
    let
      result = lib.mapNullable removeNull x;
    in
    if result == [ ] then null else result;
  serializeEntries =
    entries: lib.mapNullable (x: lib.strings.concatStringsSep " " x) (sanitizeList entries);
  serializeProps =
    props:
    let
      serializeItem = name: value: if value == null then null else "${name}=${value}";
      serializeList = x: lib.attrsets.mapAttrsToList serializeItem x;
      serialized = lib.mapNullable serializeList props;
    in
    serializeEntries serialized;
  serializeChildren =
    nodes:
    let
      serialized = serializeNodes {
        inherit nodes;
        isChildren = true;
      };
      format = x: "{\n${indentNodes x}\n}";
    in
    lib.mapNullable format serialized;
  serializeNode =
    node:
    let
      children = serializeChildren node.children;
      args = serializeEntries node.args;
      props = serializeProps node.props;
      parts = removeNull [
        node.name
        args
        props
        children
      ];
      result = lib.strings.concatStringsSep " " parts;
    in
    if children == null then "${result};" else result;
  serializeNodes =
    { nodes, isChildren }:
    let
      sanitized = sanitizeList nodes;
      serializeList = x: map serializeNode x;
      serialized = lib.mapNullable serializeList sanitized;
      sep = if isChildren then "\n" else "\n\n";
    in
    lib.mapNullable (lib.strings.concatStringsSep sep) serialized;
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
in
{
  inherit mkNode;
  mkNodeOptional =
    cond: name: data:
    if cond then mkNode name data else null;
  mkNodeWithArgs = name: args: mkNode name { inherit args; };
  mkNodeWithProps = name: props: mkNode name { inherit props; };
  mkNodeWithChildren = name: children: mkNode name { inherit children; };
  mkDocument =
    nodes:
    serializeNodes {
      inherit nodes;
      isChildren = false;
    };
  types =
    let
      mkString = x: ''"${x}"'';
    in
    {
      mkString = lib.mapNullable mkString;
      mkBool = lib.mapNullable lib.boolToString;
      mkFloat = lib.mapNullable builtins.toString;
      mkInteger = lib.mapNullable builtins.toString;
    };
}
