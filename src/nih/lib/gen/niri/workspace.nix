lib: kdl: args: {
  mk =
    {
      name,
      openOnOutput ? null,
    }:
    kdl.mkNode ''workspace "${name}"'' {
      children = [ (args.mkString "open-on-output" openOnOutput) ];
    };
}
