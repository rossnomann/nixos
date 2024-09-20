kdl: args: props:
let
  mkEasing =
    {
      curve,
      duration,
      off ? false,
    }:
    [
      (args.mkString "curve" curve)
      (args.mkFloat "duration-ms" duration)
      (kdl.mkNodeBool "off" off)
    ];
  mkSpring =
    {
      dampingRatio,
      epsilon,
      stiffness,
      off ? false,
    }:
    [
      (kdl.mkNodeBool "off" off)
      (kdl.mkNode "spring" {
        props = [
          (props.mkFloat "damping-ratio" dampingRatio)
          (props.mkFloat "stiffness" stiffness)
          (props.mkFloat "epsilon" epsilon)
        ];
      })
    ];
  mkSection = name: children: kdl.mkNode name { children = children; };
  mkConfigNotification = mkSection "config-notification-open-close";
  mkHorizontalViewMovement = mkSection "horizontal-view-movement";
  mkScreenshotUi = mkSection "screenshot-ui-open";
  mkWindowClose = mkSection "window-close";
  mkWindowMovement = mkSection "window-movement";
  mkWindowOpen = mkSection "window-open";
  mkWindowResize = mkSection "window-resize";
  mkWorkspaceSwitch = mkSection "workspace-switch";
in
{
  inherit
    mkEasing
    mkSpring
    ;
  curves = {
    easeOutQuad = "ease-out-quad";
    easeOutCubic = "ease-out-cubic";
    easeAoutExpo = "ease-out-expo";
    linear = "linear";
  };
  mk =
    {
      sections ? [ ],
      off ? false,
      slowdown ? null,
    }:
    let
      options = [
        (kdl.mkNodeBool "off" off)
        (args.mkFloat "slowdown" slowdown)
      ];
    in
    kdl.mkNode "animations" { children = (sections ++ options); };
  mkConfigNotificationEasing = props: mkConfigNotification (mkEasing props);
  mkConfigNotificationSpring = props: mkConfigNotification (mkSpring props);
  mkHorizontalViewMovementEasing = props: mkHorizontalViewMovement (mkEasing props);
  mkHorizontalViewMovementSpring = props: mkHorizontalViewMovement (mkSpring props);
  mkScreenshotUiEasing = props: mkScreenshotUi (mkEasing props);
  mkScreenshotUiSpring = props: mkScreenshotUi (mkSpring props);
  mkWindowCloseEasing = props: mkWindowClose (mkEasing props);
  mkWindowCloseSpring = props: mkWindowClose (mkSpring props);
  mkWindowMovementEasing = props: mkWindowMovement (mkEasing props);
  mkWindowMovementSpring = props: mkWindowMovement (mkSpring props);
  mkWindowOpenEasing = props: mkWindowOpen (mkEasing props);
  mkWindowOpenSpring = props: mkWindowOpen (mkSpring props);
  mkWindowResizeEasing = props: mkWindowResize (mkEasing props);
  mkWindowResizeSpring = props: mkWindowResize (mkSpring props);
  mkWorkspaceSwitchEasing = props: mkWorkspaceSwitch (mkEasing props);
  mkWorkspaceSwitchSpring = props: mkWorkspaceSwitch (mkSpring props);
}
