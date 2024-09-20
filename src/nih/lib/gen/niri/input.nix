lib: kdl: args: props:
let
  mkFocusFollowsMouse =
    {
      maxScrollAmount ? null,
    }:
    kdl.mkNode "focus-follows-mouse" {
      props = [ (props.mkStringMap "max-scroll-amount" (x: "${builtins.toString x}%") maxScrollAmount) ];
    };
  mkKeyboardXkb =
    {
      layout,
      options,
      variant,
    }:
    kdl.mkNode "xkb" {
      children = [
        (args.mkString "layout" layout)
        (args.mkString "options" options)
        (args.mkString "variant" variant)
      ];
    };
  mkKeyboard =
    {
      xkb ? null,
      repeatDelay ? null,
      repeatRate ? null,
      trackLayout ? null,
    }:
    kdl.mkNode "keyboard" {
      children = [
        (lib.mapNullable mkKeyboardXkb xkb)
        (args.mkInteger "repeat-delay" repeatDelay)
        (args.mkFloat "repeat-rate" repeatRate)
        (args.mkString "track-layout" trackLayout)
      ];
    };
  mkMouse =
    {
      accelSpeed ? null,
      accelProfile ? null,
      leftHanded ? false,
      middleEmulation ? false,
      naturalScroll ? false,
      off ? false,
      scrollMethod ? null,
    }:
    kdl.mkNode "mouse" {
      children = [
        (args.mkFloat "accel-speed" accelSpeed)
        (args.mkString "accel-profile" accelProfile)
        (kdl.mkNodeBool "left-handed" leftHanded)
        (kdl.mkNodeBool "middle-emulation" middleEmulation)
        (kdl.mkNodeBool "natural-scroll" naturalScroll)
        (kdl.mkNodeBool "off" off)
        (args.mkString "scroll-method" scrollMethod)
      ];
    };
  mkTouchpad =
    {
      accelSpeed ? null,
      accelProfile ? null,
      clickMethod ? null,
      disabledOnExternalMouse ? false,
      dwt ? false,
      dwtp ? false,
      leftHanded ? false,
      middleEmulation ? false,
      naturalScroll ? false,
      off ? false,
      scrollMethod ? null,
      tap ? false,
      tapButtonMap ? null,
    }:
    kdl.mkNode "touchpad" {
      children = [
        (args.mkFloat "accel-speed" accelSpeed)
        (args.mkString "accel-profile" accelProfile)
        (args.mkString "click-method" clickMethod)
        (kdl.mkNodeBool "disabled-on-external-mouse" disabledOnExternalMouse)
        (kdl.mkNodeBool "dwt" dwt)
        (kdl.mkNodeBool "dwtp" dwtp)
        (kdl.mkNodeBool "left-handed" leftHanded)
        (kdl.mkNodeBool "middle-emulation" middleEmulation)
        (kdl.mkNodeBool "natural-scroll" naturalScroll)
        (kdl.mkNodeBool "off" off)
        (args.mkString "scroll-method" scrollMethod)
        (kdl.mkNodeBool "tap" tap)
        (args.mkString "tap-button-map" tapButtonMap)
      ];
    };
in
{
  mk =
    {
      keyboard ? null,
      mouse ? null,
      touchpad ? null,
      focusFollowsMouse ? null,
      warpMouseToFocus ? false,
      workspaceAutoBackAndForth ? false,
    }:
    kdl.mkNode "input" {
      children = [
        (lib.mapNullable mkKeyboard keyboard)
        (lib.mapNullable mkMouse mouse)
        (lib.mapNullable mkTouchpad touchpad)
        (lib.mapNullable mkFocusFollowsMouse focusFollowsMouse)
        (kdl.mkNodeBool "warp-mouse-to-focus" warpMouseToFocus)
        (kdl.mkNodeBool "workspace-auto-back-and-forth" workspaceAutoBackAndForth)
      ];
    };
}
