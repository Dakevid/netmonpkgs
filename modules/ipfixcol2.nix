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
    elementsDir = mkOption {
      type = types.str;
      default = "";
      description = "Path to directory with IPFIX Information Elements definitions (optional)";
      example = "/etc/ipfix-elements/";
    };
  };

  config = mkIf config.services.ipfixcol2.enable {
    environment.etc."ipfixcol2/${builtins.baseNameOf config.services.ipfixcol2.configXml}" = {
      source = config.services.ipfixcol2.configXml;
    };
    systemd.services.ipfixcol2 = {
      description = "ipfixcol2 service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        elementsArg = if config.services.ipfixcol2.elementsDir != "" then "-e ${config.services.ipfixcol2.elementsDir}" else "";
      in {
        ExecStart = "${pkgs.ipfixcol2}/bin/ipfixcol2 -c /etc/ipfixcol2/${builtins.baseNameOf  config.services.ipfixcol2.configXml} ${elementsArg} ${config.services.ipfixcol2.verbosity}";
        Restart = "always";
      };
    };
  };
}