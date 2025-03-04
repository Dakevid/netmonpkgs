{
  description = "NETwork MONitoring PacKaGeS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages = {
        libfds = pkgs.callPackage ./pkgs/libfds/default.nix { };
        ipfixcol2 = pkgs.callPackage ./pkgs/ipfixcol2/default.nix {
          libfds = self.packages.libfds;
        };
        nemea-framework = pkgs.callPackage ./pkgs/nemea-framework/default.nix { };
        ipfixcol2-unirec-plugin = pkgs.callPackage ./pkgs/ipfixcol2-unirec-plugin/default.nix {
          libfds = self.packages.libfds;
          ipfixcol2 = self.packages.ipfixcol2;
          nemea-framework = self.packages.nemea-framework;
        };
        ipfixcol2-unirec = pkgs.callPackage ./pkgs/ipfixcol2-unirec/default.nix {
          ipfixcol2 = self.packages.ipfixcol2;
          ipfixcol2-unirec-plugin = self.packages.ipfixcol2-unirec-plugin;
        };
      };

      overlays = [
        (final: prev: {
          libfds = final.callPackage ./pkgs/libfds/default.nix { };
          ipfixcol2 = final.callPackage ./pkgs/ipfixcol2/default.nix {
            libfds = self.packages.libfds;
          };
          nemea-framework = final.callPackage ./pkgs/nemea-framework/default.nix { };
          ipfixcol2-unirec-plugin = final.callPackage ./pkgs/ipfixcol2-unirec-plugin/default.nix {
            libfds = self.packages.libfds;
            ipfixcol2 = self.packages.ipfixcol2;
            nemea-framework = self.packages.nemea-framework;
          };
          ipfixcol2-unirec = final.callPackage ./pkgs/ipfixcol2-unirec/default.nix {
            ipfixcol2 = self.packages.ipfixcol2;
            ipfixcol2-unirec-plugin = self.packages.ipfixcol2-unirec-plugin;
          };
        })
      ];

      nixosModules = {
        ipfixcol2 = import ./modules/ipfixcol2.nix;
      };
    };
}

