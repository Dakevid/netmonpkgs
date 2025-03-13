{ config, lib, pkgs, ... }:
with lib;
let
  cfgs = config.services.general-nemea-module.instances;
in {
  options.services.general-nemea-module = {
    enable = mkEnableOption "Enable nemea module service";
    instances = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          package = mkOption {
            type = types.package;
            default = pkgs.nemea-modules;
            description = "Nemea module package";
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
      description = "Instances of the nemea module service";
    };
  };

  config = {
    systemd.services = mapAttrs' (name: cfg: {
      description = "${cfg.module} service instance ${name}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${cfg.module} -i \"${cfg.in-ifc},${cfg.out-ifc}\" ${cfg.args}";
        Restart = "always";
      };
    }) (if config.services.general-nemea-module.enable then cfgs else {});
  };
}