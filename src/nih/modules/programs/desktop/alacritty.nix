{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nih;
  cfgPrograms = cfg.programs;
  cfgSources = cfg.sources;
  cfgStyle = cfg.style;
  package = pkgs.alacritty.overrideAttrs (oldAttrs: {
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      pkgs.mesa
      pkgs.libglvnd
    ];
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/alacritty \
        --set LD_LIBRARY_PATH "${pkgs.libglvnd}/lib:${pkgs.mesa}/lib"
    '';
  });
in
{
  options.nih.programs.desktop.alacritty = {
    executable = lib.mkOption { type = lib.types.str; };
    runCommand = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    nih.programs.desktop.alacritty.executable = "${package}/bin/alacritty";
    nih.programs.desktop.alacritty.runCommand = "${cfgPrograms.desktop.alacritty.executable} --command";
    nih.user.home.file = {
      ".config/alacritty/alacritty.toml".text =
        let
          fontMonospace = cfgStyle.fonts.monospace;
          themePath = "${cfgSources.catppuccin-alacritty}/catppuccin-${cfgStyle.palette.variant}.toml";
        in
        ''
          [general]
          import = ["${themePath}"]
          [cursor.style]
          blinking = "Always"
          shape = "Beam"
          [font]
          size = ${builtins.toString fontMonospace.defaultSize}
          [font.normal]
          family = "${fontMonospace.family}"
          [scrolling]
          history = 100000
          [window]
          decorations = "None"
          [window.padding]
          x = 20
          y = 10
        '';
    };
    nih.graphicalSession.windowRules = [
      {
        appId = ''^Alacritty'';
        workspace = "terminal";
      }
    ];
  };
}
