{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam ];
}
