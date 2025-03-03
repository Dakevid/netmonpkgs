{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  libfds,
  docutils,
  libxml2,
  rdkafka,
  zlib,
  lz4
}:

stdenv.mkDerivation rec {
  pname = "ipfixcol2";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "ipfixcol2";
    tag = "v${version}";
    hash = "sha256-SVGS2ipPjG4LOH99mv7QM/cgT2XaCya9P5/udup2x9g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libfds docutils libxml2 rdkafka zlib lz4 ];

  meta = {
    description = "Flexible, high-performance NetFlow v5/v9 and IPFIX flow data collector designed to be extensible by plugins";
    homepage = "https://github.com/CESNET/ipfixcol2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}