{ config, lib, ... }:
let
  cfg = config.nih;
in
{
  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      cups-pdf.enable = true;
    };
  };
}
