{  ... }:
{
  config = {
    environment.etc."/udev/rules.d/99-vial.rules".text = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="100", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
