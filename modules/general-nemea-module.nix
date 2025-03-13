{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.general-nemea-module;
  # Default values for optional instance fields.
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
      # Each instance is expected to be a set with these keys.
      type = types.attrsOf (types.attrs {
        module   = types.str;
        binary   = types.nullOr types.str;
        in-ifc   = types.str;
        out-ifc  = types.str;
        args     = types.str;
        displayName = types.str;
      });
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
        Each attribute key is an instance name and its value is a set containing:
          - module: the name of the module (mandatory)
          - in-ifc: the input interface (mandatory)
          - out-ifc: the output interface (mandatory)
          - binary: (optional) override for the binary path; if omitted, the default is ${config.services.general-nemea-module.package}/bin/<module>
          - args: (optional) additional arguments (default is empty)
          - displayName: (optional) display name for the service instance (default is empty)
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = lib.mapAttrs' (instanceName: instance: let
        # Merge each instance with default values for optional fields.
        inst = instance // defaultInstance;
        # Determine the binary path.
        binaryPath = if inst.binary != null
                     then inst.binary
                     else "${cfg.package}/bin/${inst.module}";
      in {
        "nemea-module@${instanceName}" = {
          description = if inst.displayName != ""
                        then "${inst.displayName} service instance (${instanceName})"
                        else "${inst.module} service instance (${instanceName})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${binaryPath} -i \"${inst.in-ifc},${inst.out-ifc}\" ${inst.args}";
            Restart = "always";
          };
        };
      }) cfg.instances;
  };
}