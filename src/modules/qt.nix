{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.qt;
in
{
  options.modules.qt = {
    enable = lib.mkEnableOption "Qt configuration";
    kvantum = {
      accent = lib.mkOption { type = lib.types.str; };
      variant = lib.mkOption { type = lib.types.str; };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      profileRelativeSessionVariables =
        let
          qtVersions = with pkgs; [
            qt5
            qt6
          ];
        in
        {
          QT_PLUGIN_PATH = map (qt: "/${qt.qtbase.qtPluginPrefix}") qtVersions;
          QML2_IMPORT_PATH = map (qt: "/${qt.qtbase.qtQmlPrefix}") qtVersions;
        };
      sessionVariables = {
        XDG_DATA_DIRS = [
          "${pkgs.gtk3}/share/gsettings-schemas/gtk+3-${pkgs.gtk3.version}"
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-${pkgs.gsettings-desktop-schemas.version}"
          "${pkgs.catppuccin-kvantum}/share"
        ];
      };
      systemPackages = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
        pkgs.catppuccin-kvantum
      ];
      variables = {
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_STYLE_OVERRIDE = "kvantum";
      };
    };
    nixpkgs.overlays =
      let
        overlay = self: super: {
          catppuccin-kvantum = super.catppuccin-kvantum.overrideAttrs {
            version = "unstable-2024-07-20";
            src = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "Kvantum";
              rev = "128d4d233d3b8d678c3b7b5ac844c72420ca6e14";
              sha256 = "sha256-O5xnLXPvOhekPjuXXB2eTujh3w8KQKWVV1sNebOG56M=";
            };
            installPhase = ''
              runHook preInstall
              mkdir -p $out/share/Kvantum
              cp -a themes/* $out/share/Kvantum
              runHook postInstall
            '';
          };
        };
      in
      [ overlay ];
    home-manager.users.${config.workspace.user.name} = {
      xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
        theme=catppuccin-${cfg.kvantum.variant}-${cfg.kvantum.accent}
      '';
    };
  };
}
