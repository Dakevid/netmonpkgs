{
  stdenv,
  lib,
  cmake,
  libfds,
  docutils,
  libxml2,
  rdkafka,
  zlib,
  lz4,
  nemea-framework,
  git,
  cacert,
  src
}:

stdenv.mkDerivation rec {
  pname = "ipfixcol2";
  version = "2.7.1-unstable";

  inherit src;

  nativeBuildInputs = [ cmake git cacert];
  buildInputs = [ libfds docutils libxml2 rdkafka zlib lz4 nemea-framework ];

  postInstall = ''
    cd ../extra_plugins/output/unirec
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_C_FLAGS="$CFLAGS -Wno-error=implicit-function-declaration" -DCMAKE_INSTALL_LIBDIR=lib
    make
    make install
    cd ../../clickhouse
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_C_FLAGS="$CFLAGS -Wno-error=implicit-function-declaration" -DCMAKE_INSTALL_LIBDIR=lib
    make
    echo "Make install cliuckhouse"
    make install
  '';

  meta = {
    description = "Flexible, high-performance NetFlow v5/v9 and IPFIX flow data collector designed to be extensible by plugins";
    homepage = "https://github.com/CESNET/ipfixcol2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
