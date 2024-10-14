{ config, lib, ... }:
let
  cfg = config.nih;
in
{
  options.nih.sources = lib.mkOption { type = lib.types.attrs; };
  config = lib.mkIf cfg.enable {
    nih.sources = import ./npins;
  };
}
