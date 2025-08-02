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
in
{
  options.nih.programs.terminal = {
    package = lib.mkOption { type = lib.types.package; };
    executable = lib.mkOption { type = lib.types.str; };
    runCommand = lib.mkOption { type = lib.types.str; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfgPrograms.terminal.package ];
    nih.programs.terminal.executable = "${cfgPrograms.terminal.package}/bin/alacritty";
    nih.programs.terminal.package = (
      pkgs.alacritty.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          pkgs.mesa
          pkgs.libglvnd
        ];
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/alacritty \
            --set LD_LIBRARY_PATH "${pkgs.libglvnd}/lib:${pkgs.mesa}/lib"
        '';
      })
    );
    nih.programs.terminal.runCommand = "${cfgPrograms.terminal.executable} --command";
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
    nih.windowRules = [
      {
        x11Class = "Alacritty";
        waylandAppId = "Alacritty";
        useWorkspace = "alacritty";
      }
    ];
  };
}
