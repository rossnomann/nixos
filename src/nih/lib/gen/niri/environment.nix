kdl: args: {
  mk = children: kdl.mkNode "environment" { inherit children; };
  mkVar = args.mkStringOrNull;
}
