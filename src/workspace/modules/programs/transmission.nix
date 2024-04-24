{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.transmission-gtk ];
}
