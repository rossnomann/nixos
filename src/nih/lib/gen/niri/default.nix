lib:
let
  __kdl = import ./_kdl.nix lib;
  __args = import ./_args.nix lib __kdl;
  __props = import ./_props.nix lib __kdl;
  _animation = import ./animation.nix __kdl __args __props;
  _bind = import ./bind.nix lib __kdl __props;
  _cursor = import ./cursor.nix __kdl __args;
  _debug = import ./debug.nix lib __kdl __args;
  _environment = import ./environment.nix __kdl __args;
  _globals = import ./globals.nix __kdl __args;
  _hotkeyOverlay = import ./hotkey-overlay.nix __kdl;
  _input = import ./input.nix lib __kdl __args __props;
  _layout = import ./layout.nix lib __kdl __args;
  _output = import ./output.nix lib __kdl __args __props;
  _windowRule = import ./window-rule.nix lib __kdl __args __props _layout;
  _workspace = import ./workspace.nix lib __kdl __args;
in
{
  animation = _animation;
  bind = _bind;
  environment = {
    inherit (_environment) mkVar;
  };
  layout = {
    inherit (_layout)
      mkPresetFixed
      mkPresetProportion
      ;
  };
  mkConfig =
    {
      binds,
      animation ? null,
      cursor ? null,
      debug ? null,
      environment ? null,
      hotkeyOverlay ? null,
      input ? null,
      layout ? null,
      outputs ? [ ],
      preferNoCsd ? false,
      spawnAtStartup ? [ ],
      screenshotPath ? null,
      windowRules ? [ ],
      workspaces ? null,
    }:
    __kdl.serialize (
      [
        (_bind.mk binds)
        (lib.mapNullable _animation.mk animation)
        (lib.mapNullable _cursor.mk cursor)
        (lib.mapNullable _debug.mk debug)
        (lib.mapNullable _environment.mk environment)
        (lib.mapNullable _hotkeyOverlay.mk hotkeyOverlay)
        (lib.mapNullable _input.mk input)
        (lib.mapNullable _layout.mk layout)
      ]
      ++ (_globals.mk {
        inherit
          preferNoCsd
          screenshotPath
          spawnAtStartup
          ;
      })
      ++ (map _output.mk outputs)
      ++ (map _windowRule.mk windowRules)
      ++ (map _workspace.mk workspaces)
    );
}
