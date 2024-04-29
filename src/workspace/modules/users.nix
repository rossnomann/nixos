{ config, pkgs, ... }:
{
  users.users.${config.workspace.user.name} = {
    description = config.workspace.user.description;
    extraGroups = config.workspace.user.groups;
    isNormalUser = true;
    shell = pkgs.nushell;
  };
  workspace.user = {
    name = "ross";
    description = "Ross Nomann";
    email = "rossnomann@protonmail.com";
    gpg_signing_key = "56D1FCBF";
    groups = [
      "audio"
      "docker"
      "networkmanager"
      "wheel"
    ];
  };
}
