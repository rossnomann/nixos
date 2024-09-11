{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.android-tools
    pkgs.scrcpy
  ];
}
