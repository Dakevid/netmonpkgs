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
      type = types.attrsOf (types.attrs {
        module = types.str;
        in-ifc = types.str;
        out-ifc = types.str;
        args = types.str;
      });
      default = {};
      description = ''
        Configuration for multiple nemea module service instances.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mkMerge (lib.mapAttrs' (instanceName: cfgInstance: {
      "nemea-module@${instanceName}" = {
        description = "${cfgInstance.module} service instance (${instanceName})";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/${cfgInstance.module} -i \"${cfgInstance.in-ifc},${cfgInstance.out-ifc}\" ${cfgInstance.args}";
          Restart = "always";
        };
      };
    }) cfg.instances);
  };
}