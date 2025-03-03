{ buildEnv, ipfixcol2, ipfixcol2-unirec-plugin }:

buildEnv {
  name = "ipfixcol2-unirec";
  paths = [ ipfixcol2 ipfixcol2-unirec-plugin ];
}
