{
  lib,
  outputs,
  workspaces,
  windowRules,
  spawnAtStartup,
  cmdTerminal,
  cmdLauncher,
  colors,
  accentColor,
  xcursorTheme,
  xcursorSize,
}:
let
  concat = x: lib.strings.concatStringsSep "\n" x;
  optionalNode = name: value: lib.optionalString (!isNull value) ''${name} ${value}'';
  optionalNodeBoolean = name: value: lib.optionalString (value == true) name;
  optionalProperty = name: value: lib.optionalString (!isNull value) ''${name}="${value}"'';
  mkSection = name: body: ''
    ${name} {
      ${concat body}
    }
  '';
  mkBindsWorkspace =
    { idx, name }:
    ''
      ${mkSection "Mod+${idx}" [ ''focus-workspace "${name}";'' ]}
      ${mkSection "Mod+Shift+${idx}" [ ''move-window-to-workspace "${name}";'' ]}
    '';
  mkWindowRule =
    {
      waylandAppId,
      title,
      useFullscreen,
      useWorkspace,
      ...
    }:
    let
      matchAppId = optionalProperty "app-id" waylandAppId;
      matchTitle = optionalProperty "title" title;
    in
    mkSection "window-rule" [
      "match ${matchAppId} ${matchTitle}"
      (lib.optionalString (useFullscreen == true) "open-fullscreen true")
      (lib.optionalString (!isNull useWorkspace) ''open-on-workspace "${useWorkspace}"'')
    ];
  mkOutput =
    {
      name,
      mode ? null,
      scale ? null,
      position ? null,
      focusAtStartup ? false,
      backdropColor,
    }:
    mkSection ''output "${name}"'' [
      (optionalNode "mode" mode)
      (optionalNode "scale" scale)
      (optionalNode "position" position)
      (optionalNodeBoolean "focus-at-startup" focusAtStartup)
      ''backdrop-color "${backdropColor}"''
      "hot-corners { off; }"
    ];
  mkBindSpawn = bind: command: mkSection bind [ "spawn ${command};" ];
  mkBindsWorkspaces = items: concat (map mkBindsWorkspace items);
  mkSpawnAtStartup = items: concat (map (item: ''spawn-at-startup ${item}'') items);
  mkWindowRules = items: concat (map mkWindowRule items);
  mkWorkspaces = items: concat (map (item: ''workspace "${item}"'') items);
  mkOutputs =
    items: backdropColor: concat (map (item: mkOutput (item // { inherit backdropColor; })) items);
  workspacesIndexed =
    let
      indexes = map builtins.toString (lib.range 1 (lib.lists.length workspaces));
    in
    lib.lists.zipListsWith (a: b: {
      idx = a;
      name = b;
    }) indexes workspaces;
in
''
  ${mkWorkspaces workspaces}

  include "base.kdl"

  binds {
    ${mkBindSpawn "Mod+Return" cmdTerminal}
    ${mkBindSpawn "Mod+R" cmdLauncher}
    ${mkBindsWorkspaces workspacesIndexed}
  }

  cursor {
    xcursor-theme "${xcursorTheme}"
    xcursor-size ${builtins.toString xcursorSize}
  }

  layout {
    border {
      active-color "${accentColor}"
      inactive-color "${colors.overlay2}"
      width 2
    }

    insert-hint { color "${colors.blue}"; }
  }

  overview { backdrop-color "${colors.crust}"; }

  recent-windows { off; }

  ${mkOutputs outputs colors.crust}

  ${mkSpawnAtStartup spawnAtStartup}

  ${mkWindowRules windowRules}
''
