{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.general-nemea-module;
  # Defaults for optional instance fields
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
      # We forego deep type-checking by accepting any attribute set for each instance.
      type = types.attrsOf types.any;
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
         # Merge user-provided instance attributes with our defaults.
         inst = instance // defaultInstance;
         # Resolve the binary path.
         binaryPath = if inst.binary != null
                      then inst.binary
                      else "${cfg.package}/bin/${inst.module}";
         # Use additional args (empty string by default)
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