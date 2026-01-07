let
  mkAssociation =
    { entry, types }:
    builtins.listToAttrs (
      map (v: {
        name = v;
        value = entry;
      }) types
    );
  types = {
    archives = [
      "application/gzip"
      "application/java-archive"
      "application/vnd.debian.binary-package"
      "application/vnd.rar"
      "application/vnd.snap"
      "application/vnd.squashfs"
      "application/x-7z-compressed"
      "application/x-archive"
      "application/x-arj"
      "application/x-bzip"
      "application/x-bzip-compressed-tar"
      "application/x-bzip1"
      "application/x-bzip1-compressed-tar"
      "application/x-bzip2"
      "application/x-bzip2-compressed-tar"
      "application/x-bzip3"
      "application/x-bzip3-compressed-tar"
      "application/x-compressed-tar"
      "application/x-lzma"
      "application/x-lzma-compressed-tar"
      "application/x-rar"
      "application/x-tar"
      "application/x-tarz"
      "application/x-xz"
      "application/x-xz-compressed-tar"
      "application/x-zstd-compressed-tar"
      "application/zip"
      "application/zstd"
    ];
    audio = [
      "audio/mpeg"
      "audio/vnd.wave"
    ];
    documents = [
      "application/epub+zip"
      "application/pdf"
      "image/vnd.djvu"
      "image/x-djvu"
      "text/fb2+xml"
    ];
    images = [
      "application/photoshop"
      "application/psd"
      "application/x-krita"
      "application/x-navi-animation"
      "application/x-photoshop"
      "image/aces"
      "image/apng"
      "image/avif"
      "image/avif-sequence"
      "image/bmp"
      "image/gif"
      "image/icns"
      "image/jpeg"
      "image/jpg"
      "image/jxl"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/webp"
      "image/heic"
      "image/heif"
      "image/openraster"
      "image/psd"
      "image/sgi"
      "image/vnd.adobe.photoshop"
      "image/vnd.radiance"
      "image/vnd.wap.wbmp"
      "image/vnd.zbrush.pcx"
      "image/x-exr"
      "image/x-icon"
      "image/x-pcx"
      "image/x-pic"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-rgb"
      "image/x-sgi-bw"
      "image/x-sgi-rgba"
      "image/x-sun-raster"
      "image/x-tga"
      "image/x-win-bitmap"
      "image/x-xbitmap"
      "image/x-xpixmap"
      "image/x-xcf"
    ];
    text = [
      "application/json"
      "application/xml"
      "application/yaml"
      "text/markdown"
      "text/plain"
      "text/x-rst"
    ];
    torrents = [
      "x-scheme-handler/magnet"
      "application/x-bittorrent"
    ];
    videos = [
      "video/3gpp"
      "video/3gpp2"
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/webm"
      "video/x-matroska"
      "video/x-msvideo"
      "video/x-ms-wmv"
    ];
  };
in
{
  mkAssociations =
    {
      archives,
      audio,
      documents,
      images,
      text,
      torrents,
      videos,
    }:
    (mkAssociation {
      entry = archives;
      types = types.archives;
    })
    // (mkAssociation {
      entry = audio;
      types = types.audio;
    })
    // (mkAssociation {
      entry = documents;
      types = types.documents;
    })
    // (mkAssociation {
      entry = images;
      types = types.images;
    })
    // (mkAssociation {
      entry = text;
      types = types.text;
    })
    // (mkAssociation {
      entry = torrents;
      types = types.torrents;
    })
    // (mkAssociation {
      entry = videos;
      types = types.videos;
    });
}
