{ prev }: nushellExecutable: prev.callPackage ./package.nix { inherit nushellExecutable; }
