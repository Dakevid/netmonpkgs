# netmonpkgs

**NETwork MONitoring PacKaGeS**

`netmonpkgs` is a Nix flake repository providing a collection of packages and NixOS modules aimed at enhancing network monitoring capabilities. This repository offers seamless integration of various tools into Nix and NixOS environments.

## Packages

The following packages are available:

- **libfds**: The library provides components for parsing and processing IPFIX Messages.

- **nemea-framework**: Base libraries for Nemea system which is a modular system that consists of independent modules for network traffic analysis and anomaly detection.

- **ipfixcol2**: Flexible, high-performance NetFlow v5/v9 and IPFIX flow data collector designed to be extensible by plugins.

- **nemea-modules**: A set of modules for the NEMEA framework.

- **nemea-modules-ng**: A set of modules ng for the NEMEA framework.

- **wif**: Library for fast development of (heterogeneous) detection and classification modules for (Encrypted) Network Traffic Analysis.

- **libdst**: Library implementation of Dempster-Shafer Theory.

- **decrypto**: NEMEA module for detection of cryptomining, based on libnemea++ and libwif.

- **telemetry**: Library designed for the collection and processing of telemetry data.

## NixOS Modules

This repository includes the following NixOS modules:

- **ipfixcol2**: Configures and manages the IPFIXcol2 service.

- **general-nemea-module**: Provides general configurations for NEMEA modules.

## Example usage

### Shell

```
nix shell github:jaroslavpesek/netmonpkgs#packages.x86_64-linux.nemea-modules
logger -i u:test
```

### Add the Flake to Your Configuration

   Add `netmonpkgs` as an input in your `flake.nix`:

   ```nix
   {
     inputs.netmonpkgs.url = "github:jaroslavpesek/netmonpkgs";
   }