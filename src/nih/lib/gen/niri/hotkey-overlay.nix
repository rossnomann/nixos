kdl: {
  mk =
    {
      skipAtStartup ? false,
    }:
    kdl.mkNode "hotkey-overlay" {
      children = [
        (kdl.mkNodeBool "skip-at-startup" skipAtStartup)
      ];
    };
}
