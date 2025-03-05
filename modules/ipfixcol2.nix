{ config, lib, pkgs, ... }:
with lib;
{
  options.services.ipfixcol2 = {
    enable = mkEnableOption "Enable ipfixcol2 service";
    configXml = mkOption {
      type = types.path;
      description = "Path to the immutable XML configuration file for ipfixcol2";
    };
    verbosity = mkOption {
      type = types.str;
      default = "";
      description = "Verbosity level of ipfixcol2 (-v, -vv, -vvv)";
    };
  };

  config = mkIf config.services.ipfixcol2.enable {
    environment.etc."ipfixcol2/config.xml".source = config.services.ipfixcol2.configXml;
    systemd.services.ipfixcol2 = {
      description = "ipfixcol2 service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ipfixcol2}/bin/ipfixcol2 -c /etc/ipfixcol2/config.xml ${config.services.ipfixcol2.verbosity}";
        Restart = "always";
      };
    };
  };
}
