{
  description = "NETwork MONitoring PacKaGeS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    ipfixcol2-src = {
      url = "git+ssh://git@gitlab.liberouter.org/monitoring/ipfixcol2.git?ref=replace-ODID";
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-utils, ipfixcol2-src, ... }:
    let
      mkPkgs = callPackage:
        let
          pkg = {
            libfds = callPackage ./pkgs/libfds/default.nix { };
            ensmallen = callPackage ./pkgs/ensmallen/default.nix { };
            mlpack = callPackage ./pkgs/mlpack/default.nix {
              ensmallen = pkg.ensmallen;
            };
            nemea-framework = callPackage ./pkgs/nemea-framework/default.nix { };
            ipranges = callPackage ./pkgs/ipranges/default.nix { };
            typedcols = callPackage ./pkgs/typedcols/default.nix { };
            idea-format = callPackage ./pkgs/idea-format/default.nix {
              ipranges = pkg.ipranges;
              typedcols = pkg.typedcols;
            };
            pynspect = callPackage ./pkgs/pynspect/default.nix {
              ipranges = pkg.ipranges;
            };
            pytrap = callPackage ./pkgs/pytrap/default.nix {
              nemea-framework = pkg.nemea-framework;
            };
            pycommon = callPackage ./pkgs/pycommon/default.nix {
              nemea-framework = pkg.nemea-framework;
              pytrap = pkg.pytrap;
              idea-format = pkg.idea-format;
              pynspect = pkg.pynspect;
            };
            ipfixcol2 = callPackage ./pkgs/ipfixcol2/default.nix {
              src = ipfixcol2-src;
              libfds = pkg.libfds;
              nemea-framework = pkg.nemea-framework;
            };
            nemea-modules = callPackage ./pkgs/nemea-modules/default.nix {
              nemea-framework = pkg.nemea-framework;
              pytrap = pkg.pytrap;
              pycommon = pkg.pycommon;
            };
            nemea-modules-ng = callPackage ./pkgs/nemea-modules-ng/default.nix {
              nemea-framework = pkg.nemea-framework;
              pytrap = pkg.pytrap;
              pycommon = pkg.pycommon;
            };
            wif = callPackage ./pkgs/wif/default.nix {
              nemea-framework = pkg.nemea-framework;
              mlpack = pkg.mlpack;
              ensmallen = pkg.ensmallen;
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
