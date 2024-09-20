kdl: args: {
  mk =
    {
      preferNoCsd ? false,
      screenshotPath ? null,
      spawnAtStartup ? [ ],
    }:
    [
      (kdl.mkNodeBool "prefer-no-csd" preferNoCsd)
      (args.mkStringOrNull "screenshot-path" screenshotPath)
    ]
    ++ (map (x: args.mkIdent "spawn-at-startup" x) spawnAtStartup);
}
