kdl: args: {
  mk =
    {
      theme ? null,
      size ? null,
    }:
    kdl.mkNode "cursor" {
      children = [
        (args.mkString "xcursor-theme" theme)
        (args.mkInteger "xcursor-size" size)
      ];
    };
}
