{ config, pkgs, ... }:
{
  home-manager.users.${config.workspace.user.name} = {
    home.packages = [
      (pkgs.gimp-with-plugins.override { plugins = [ pkgs.gimpPlugins.gmic ]; })
      pkgs.inkscape
      pkgs.qview
    ];
    xdg = {
      dataFile."applications/com.interversehq.qView.desktop".source = ./resources/com.interversehq.qView.desktop;
      mimeApps.defaultApplications =
        let
          defaults = [ "com.interversehq.qView.desktop" ];
        in
        {
          "application/photoshop" = defaults;
          "application/psd" = defaults;
          "application/x-krita" = defaults;
          "application/x-navi-animation" = defaults;
          "application/x-photoshop" = defaults;
          "image/aces" = defaults;
          "image/apng" = defaults;
          "image/avif" = defaults;
          "image/avif-sequence" = defaults;
          "image/bmp" = defaults;
          "image/gif" = defaults;
          "image/icns" = defaults;
          "image/jpeg" = defaults;
          "image/jpg" = defaults;
          "image/jxl" = defaults;
          "image/png" = defaults;
          "image/svg+xml" = defaults;
          "image/tiff" = defaults;
          "image/webp" = defaults;
          "image/heic" = defaults;
          "image/heif" = defaults;
          "image/openraster" = defaults;
          "image/psd" = defaults;
          "image/sgi" = defaults;
          "image/vnd.adobe.photoshop" = defaults;
          "image/vnd.radiance" = defaults;
          "image/vnd.wap.wbmp" = defaults;
          "image/vnd.zbrush.pcx" = defaults;
          "image/x-exr" = defaults;
          "image/x-icon" = defaults;
          "image/x-pcx" = defaults;
          "image/x-pic" = defaults;
          "image/x-portable-bitmap" = defaults;
          "image/x-portable-graymap" = defaults;
          "image/x-portable-pixmap" = defaults;
          "image/x-rgb" = defaults;
          "image/x-sgi-bw" = defaults;
          "image/x-sgi-rgba" = defaults;
          "image/x-sun-raster" = defaults;
          "image/x-tga" = defaults;
          "image/x-win-bitmap" = defaults;
          "image/x-xbitmap" = defaults;
          "image/x-xpixmap" = defaults;
          "image/x-xcf" = defaults;
        };
    };
  };
}
