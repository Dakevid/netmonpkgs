{
  description = "NETwork MONitoring PacKaGeS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { nixpkgs, ... }:
  let
    systems = [ "x86_64-linux" ];

    mkPkgs = callPackage: let pkg = {
      libfds = callPackage ./pkgs/libfds/default.nix { };
      nemea-framework = callPackage ./pkgs/nemea-framework/default.nix { };
      ipfixcol2 = callPackage ./pkgs/ipfixcol2/default.nix {
        libfds = pkg.libfds;
        nemea-framework = pkg.nemea-framework;
      };
      nemea-modules = callPackage ./pkgs/nemea-modules/default.nix {
        nemea-framework = pkg.nemea-framework;
      };
      nemea-modules-ng = callPackage ./pkgs/nemea-modules-ng/default.nix {
        nemea-framework = pkg.nemea-framework;
      };
      wif = callPackage ./pkgs/wif/default.nix { 
        nemea-framework = pkg.nemea-framework;
      };
      libdst = callPackage ./pkgs/libdst/default.nix { };
      decrypto = callPackage ./pkgs/decrypto/default.nix {
        wif = pkg.wif;
        nemea-framework = pkg.nemea-framework;
        libdst = pkg.libdst;
      };
      telemetry = callPackage ./pkgs/telemetry/default.nix { };
      nemea-modules-meta = callPackage ./pkgs/nemea-modules-meta/default.nix {
        nemea-modules = pkg.nemea-modules;
        nemea-modules-ng = pkg.nemea-modules-ng;
        decrypto = pkg.decrypto;
      };
    }; in pkg;
  in {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = let
        pkgs = import nixpkgs { inherit system; };
      in mkPkgs pkgs.callPackage;
    }) systems);

    overlays = {
      default = final: prev: mkPkgs final.callPackage;
    };

    nixosModules = {
      ipfixcol2 = import ./modules/ipfixcol2.nix;
      general-nemea-module = import ./modules/general-nemea-module.nix;
    };
  };
}