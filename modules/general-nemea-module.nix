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
    modules = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
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
      description = "A set of Nemea module configurations.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mapAttrs (name: moduleCfg: {
      description = "${moduleCfg.module} service instance ${name}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${moduleCfg.module} -i \"${moduleCfg.in-ifc},${moduleCfg.out-ifc}\" ${moduleCfg.args}";
        Restart = "always";
      };
    }) cfg.modules;
  };
}