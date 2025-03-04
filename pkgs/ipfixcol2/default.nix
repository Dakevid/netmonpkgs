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
  lz4,
  nemea-framework ? null
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
  buildInputs = [ libfds docutils libxml2 rdkafka zlib lz4 ]
    ++ (if nemea-framework != null then [ nemea-framework ] else []);

  postInstall = if nemea-framework != null then ''
    cd ../extra_plugins/output/unirec
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_C_FLAGS="$CFLAGS -Wno-error=implicit-function-declaration" -DCMAKE_INSTALL_LIBDIR=lib
    make
    make install
  '' else "";

  meta = {
    description = "Flexible, high-performance NetFlow v5/v9 and IPFIX flow data collector designed to be extensible by plugins";
    homepage = "https://github.com/CESNET/ipfixcol2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
