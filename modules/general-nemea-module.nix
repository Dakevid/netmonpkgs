{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.general-nemea-module;
in {
  options.services.general-nemea-module = {
    enable = mkEnableOption "Enable nemea module service";
    package = mkOption {
      type = types.package;
      default = pkgs.nemea-modules;
      description = "Nemea module package";
    };
    instances = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          module = mkOption {
            type = types.str;
            description = "Name of the nemea module (should match the binary name if 'binary' is not overridden)";
          };
          binary = mkOption {
            type = types.str;
            default = null;
            description = "Optional absolute path to the binary. If null, defaults to package's bin directory.";
          };
          in-ifc = mkOption {
            type = types.str;
            description = "Input interface for the nemea module";
          };
          out-ifc = mkOption {
            type = types.str;
            description = "Output interface for the nemea module";
          };
          args = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Additional arguments for the nemea module (each argument is a separate string)";
          };
          displayName = mkOption {
            type = types.str;
            default = "";
            description = "Optional display name for the service instance";
          };
        };
      });
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
        Each attribute key is an instance name and its value is a configuration
        attribute set containing the module name, input and output interfaces,
        and optional binary override, additional arguments, and display name.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = lib.mapAttrs' (instanceName: cfgInstance: let
        binaryPath = if cfgInstance.binary != null
                     then cfgInstance.binary
                     else "${cfg.package}/bin/${cfgInstance.module}";
        argsStr = if cfgInstance.args == [] then ""
                  else lib.concatStringsSep " " (map builtins.escapeShellArg cfgInstance.args);
      in {
        "nemea-module@${instanceName}" = {
          description = if cfgInstance.displayName != "" 
                        then "${cfgInstance.displayName} service instance (${instanceName})"
                        else "${cfgInstance.module} service instance (${instanceName})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = ''
              ${binaryPath} -i "${builtins.escapeShellArg cfgInstance.in-ifc},${builtins.escapeShellArg cfgInstance.out-ifc}" ${argsStr}
            '';
            Restart = "always";
          };
        };
      }) cfg.instances;
  };
}