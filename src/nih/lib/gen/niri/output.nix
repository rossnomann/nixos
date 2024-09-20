lib: kdl: args: props: {
  mk =
    {
      name,
      backgroundColor ? null,
      mode ? null,
      off ? false,
      position ? null,
      scale ? null,
      transform ? null,
      vfr ? null,
    }:
    kdl.mkNode ''output "${name}"'' {
      children = [
        (args.mkString "background-color" backgroundColor)
        (args.mkString "mode" mode)
        (kdl.mkNodeBool "off" off)
        (lib.mapNullable (
          { x, y }:
          kdl.mkNode "position" {
            props = [
              (props.mkInteger "x" x)
              (props.mkInteger "y" y)
            ];
          }
        ) position)
        (args.mkFloat "scale" scale)
        (args.mkString "transform" transform)
        (lib.mapNullable (
          {
            onDemand ? null,
          }:
          kdl.mkNode "variable-refresh-rate" {
            props = [
              (props.mkBool "on-demand" onDemand)
            ];
          }
        ) vfr)
      ];
    };
}
