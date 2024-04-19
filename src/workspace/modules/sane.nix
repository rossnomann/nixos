{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gnome.simple-scan ];
  services.saned.enable = true;
}
