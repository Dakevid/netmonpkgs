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
    # Use a fixed attributes type instead of a submodule to avoid requiring a "name" attribute.
    instances = mkOption {
      type = types.attrsOf (types.attrs {
        module = types.str;
        binary = types.nullOr types.str;
        in-ifc = types.str;
        out-ifc = types.str;
        args = types.listOf types.str;
        displayName = types.str;
      });
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
        Each attribute key is an instance name and its value is a configuration
        attribute set containing the module name, input and output interfaces,
        optional binary override, additional arguments, and display name.
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