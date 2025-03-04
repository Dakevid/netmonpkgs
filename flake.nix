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
        nemea-framework = pkgs.callPackage ./pkgs/nemea-framework/default.nix { };
        ipfixcol2 = pkgs.callPackage ./pkgs/ipfixcol2/default.nix {
          libfds = self.packages.libfds;
          nemea-framework = self.packages.nemea-framework;
        };
        nemea-modules = pkgs.callPackage ./pkgs/nemea-modules/default.nix {
          nemea-framework = self.packages.nemea-framework;
        };
      };

      overlays = {
        default = final: prev: {
          libfds = final.callPackage ./pkgs/libfds/default.nix { };
          nemea-framework = final.callPackage ./pkgs/nemea-framework/default.nix { };
          ipfixcol2 = final.callPackage ./pkgs/ipfixcol2/default.nix {
            libfds = self.packages.libfds;
            nemea-framework = self.packages.nemea-framework;
          };
        };
      };

      nixosModules = {
        ipfixcol2 = import ./modules/ipfixcol2.nix;
      };
    };
}

