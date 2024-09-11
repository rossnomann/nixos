{ config, lib, ... }:
let
  cfg = config.nih;
  cfgPalette = cfg.palette;
in
{
  options.nih.palette = {
    variant = lib.mkOption { type = lib.types.str; };
    accent = lib.mkOption { type = lib.types.str; };
    colors = lib.mkOption {
      type = lib.types.attrs;
      default = lib.getAttr cfgPalette.variant lib.nih.catppuccin.colors;
    };
  };
}
