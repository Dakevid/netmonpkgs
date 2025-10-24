{
  description = "NETwork MONitoring PacKaGeS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      mkPkgs = callPackage:
        let
          pkg = {
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
          };
        in
        pkg;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          packages = mkPkgs pkgs.callPackage;
        in
        {
          packages = packages // {
            default = packages.nemea-modules-meta;
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixd
              nixpkgs-fmt
            ];
          };

          formatter = pkgs.nixpkgs-fmt;
        }
      ) // {
      overlays = {
        default = final: prev: mkPkgs final.callPackage;
      };

      nixosModules = {
        ipfixcol2 = import ./modules/ipfixcol2.nix;
        general-nemea-module = import ./modules/general-nemea-module.nix;
      };
    };
}
