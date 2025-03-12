{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.general-nemea-module;
in {
  options.services.general-nemea-module = {
    enable = mkEnableOption "Enable nemea module service";
    package = mkPackageOption {
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

  config = mkIf cfg.enable {
    systemd.services.general-nemea-module = {
      description = "${cfg.module} service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${cfg.module} -i \"${cfg.in-ifc},${cfg.out-ifc}\" ${cfg.args}";
        Restart = "always";
      };
    };
  };
}