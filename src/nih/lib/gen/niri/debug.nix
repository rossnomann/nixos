lib: kdl: args: {
  mk =
    {
      dbusInterfacesInNonSessionInstances ? false,
      disableCursorPlane ? false,
      disableDirectScanout ? false,
      disableResizeThrottling ? false,
      disableTransactions ? false,
      emulateZeroPresentationTime ? false,
      enableOverlayPlanes ? false,
      previewRender ? null,
      renderDrmDevice ? null,
      waitForFrameCompletionBeforeQueueing ? false,
    }:
    kdl.mkNode "debug" {
      children = [
        (kdl.mkNodeBool "dbus-interfaces-in-non-session-instances" dbusInterfacesInNonSessionInstances)
        (kdl.mkNodeBool "disable-cursor-plane" disableCursorPlane)
        (kdl.mkNodeBool "disable-direct-scanout" disableDirectScanout)
        (kdl.mkNodeBool "disable-resize-throttling" disableResizeThrottling)
        (kdl.mkNodeBool "disable-transactions" disableTransactions)
        (kdl.mkNodeBool "emulate-zero-presentation-time" emulateZeroPresentationTime)
        (kdl.mkNodeBool "enable-overlay-planes" enableOverlayPlanes)
        (args.mkString "preview-render" previewRender)
        (args.mkString "render-drm-device" renderDrmDevice)
        (kdl.mkNodeBool "wait-for-frame-completion-before-queueing" waitForFrameCompletionBeforeQueueing)
      ];
    };

}
