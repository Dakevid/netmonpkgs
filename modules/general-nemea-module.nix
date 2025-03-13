{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.general-nemea-module;
  # Default values for optional instance keys.
  defaultInstance = {
    binary = null;
    args = "";
    displayName = "";
  };
in {
  options.services.general-nemea-module = {
    enable = mkEnableOption "Enable nemea module service";
    package = mkOption {
      type = types.package;
      default = pkgs.nemea-modules;
      description = "Nemea module package";
    };
    instances = mkOption {
      # Accept an attribute set for each instance without deep type-checking.
      type = types.attrsOf lib.types.anything;
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
        Each attribute key is an instance name and its value must be an attribute set containing:
          - module: (string) the name of the module (mandatory)
          - in-ifc: (string) the input interface (mandatory)
          - out-ifc: (string) the output interface (mandatory)
          - binary: (optional, string or null) override for the binary path
          - args: (optional, string) additional arguments (default: "")
          - displayName: (optional, string) display name for the service instance (default: "")
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mapAttrs' (instanceName: instance: let
         # Merge each instance with our default values.
         inst = instance // defaultInstance;
         # Determine the binary path: if no custom binary is given, default to the package's bin directory.
         binaryPath = if inst.binary != null
                      then inst.binary
                      else "${cfg.package}/bin/${inst.module}";
         argsStr = inst.args;
      in {
        "nemea-module@${instanceName}" = {
          description = if inst.displayName != ""
                        then "${inst.displayName} service instance (${instanceName})"
                        else "${inst.module} service instance (${instanceName})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${binaryPath} -i \"${inst.in-ifc},${inst.out-ifc}\" ${argsStr}";
            Restart = "always";
          };
        };
      }) cfg.instances;
  };
}