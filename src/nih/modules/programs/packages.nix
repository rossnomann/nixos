{
  fretboard,
  pkgs,
  pkgs20251111,
  cfgSources,
}:
{
  inherit (pkgs)
    alacritty
    ardour
    discord
    exiftool
    file
    helvum
    htop
    imagemagick
    inkscape
    lame
    libreoffice
    loupe
    lshw
    macchina
    mc
    mpv
    overskride
    pciutils
    rofi
    scrcpy
    simple-scan
    slack
    syncplay
    telegram-desktop
    transmission_4-gtk
    trash-cli
    unrar
    usbutils
    wiremix
    xarchiver
    zathura
    ;
  deadbeef = pkgs20251111.deadbeef;
  firefox =
    let
      extraPolicies = import ./resources/firefox-policies.nix;
    in
    pkgs.firefox.override { inherit extraPolicies; };
  fretboard = fretboard.packages.${pkgs.stdenv.hostPlatform.system}.default;
  gimp = pkgs.gimp3-with-plugins.override {
    plugins = [ pkgs.gimp3Plugins.gmic ];
  };
  mpvCatppuccin =
    let
      src = cfgSources.catppuccin-mpv;
    in
    pkgs.stdenvNoCC.mkDerivation {
      inherit src;
      pname = "catppuccin-mpv";
      version = src.revision;
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        find themes/*.conf -type f -exec sed -i "s/^background-color=.*$/background-color=\'#000000\'/g" {} +
        cp -a themes/* $out
        runHook postInstall
      '';
    };
  nohupXdgOpen = pkgs.writeShellScriptBin "nohup-xdg-open" ''
    ${pkgs.coreutils}/bin/nohup ${pkgs.xdg-utils}/bin/xdg-open "$@" >/dev/null 2>&1 &
  '';
  obsidian =
    let
      obsidianHook = pkgs.writeTextFile {
        name = "obsidian-hook";
        text = builtins.readFile ./resources/obsidian-hook;
        executable = true;
      };
    in
    (pkgs.obsidian.overrideAttrs (_: {
      postInstall = ''
        sed -i '1 a ${obsidianHook}' $out/bin/obsidian
      '';
    }));
}
