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
    unirecMappingFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to UniRec fields mapping file (optional, expected to match <mappingFile> path in config XML)";
      example = "/etc/ipfixcol2/unirec-mapping.xml";
    };
  };

  config = mkIf config.services.ipfixcol2.enable {
    environment.etc."ipfixcol2/${builtins.baseNameOf config.services.ipfixcol2.configXml}" = {
      source = config.services.ipfixcol2.configXml;
    };

    # Only mount the mapping file if it's provided
    environment.etc."ipfixcol2/unirec-mapping.xml" = mkIf (config.services.ipfixcol2.unirecMappingFile != null) {
      source = config.services.ipfixcol2.unirecMappingFile;
    };

    systemd.services.ipfixcol2 = {
      description = "ipfixcol2 service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        cfg = config.services.ipfixcol2;
        elementsArg = if cfg.elementsDir != "" then "-e ${cfg.elementsDir}" else "";
      in {
        ExecStart = "${pkgs.ipfixcol2}/bin/ipfixcol2 -c /etc/ipfixcol2/${builtins.baseNameOf cfg.configXml} ${elementsArg} ${cfg.verbosity}";
        Restart = "always";
      };
    };
  };
}
