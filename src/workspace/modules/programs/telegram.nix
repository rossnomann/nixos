{ pkgs, ... }:
{
  workspace.home.home.packages = [ pkgs.telegram-desktop ];
}
