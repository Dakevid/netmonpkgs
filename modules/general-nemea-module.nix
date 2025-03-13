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
          name = mkOption {
            type = types.str;
            default = "";
            description = "Optional instance name. If not provided, the instance key will be used.";
          };
          module = mkOption {
            type = types.str;
            description = "Name of nemea module";
          };
          in-ifc = mkOption {
            type = types.str;
            description = "Input interface for nemea module";
          };
          out-ifc = mkOption {
            type = types.str;
            description = "Output interface for nemea module";
          };
          args = mkOption {
            type = types.str;
            default = "";
            description = "Additional arguments for nemea module";
          };
        };
      });
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
        Each attribute key is an instance name and its value is a configuration
        attribute set.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = lib.mapAttrs' (instanceName: cfgInstance:
      let
        instanceDisplayName = if cfgInstance.name != "" then cfgInstance.name else instanceName;
      in {
        "general-nemea-module@${instanceName}" = {
          description = "${cfgInstance.module} service instance (${instanceDisplayName})";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/${cfgInstance.module} -i \"${cfgInstance.in-ifc},${cfgInstance.out-ifc}\" ${cfgInstance.args}";
            Restart = "always";
          };
        };
      }
    ) cfg.instances;
  };
}