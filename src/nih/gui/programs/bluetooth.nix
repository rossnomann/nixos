{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.overskride ];
}
