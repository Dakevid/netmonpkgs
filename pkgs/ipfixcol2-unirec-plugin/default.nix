{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  ipfixcol2,
  nemea-framework,
  libfds,
  docutils
}:

stdenv.mkDerivation rec {
  pname = "ipfixcol2-unirec-plugin";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "ipfixcol2";
    tag = "v${version}";
    hash = "sha256-SVGS2ipPjG4LOH99mv7QM/cgT2XaCya9P5/udup2x9g=";
  };

  configurePhase = ''
    cd extra_plugins/output/unirec
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_C_FLAGS="$CFLAGS -Wno-error=implicit-function-declaration"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cmake nemea-framework docutils libfds ipfixcol2 ];

  meta = {
    description = "Unirec plugin for ipfixcol2";
    homepage = "https://github.com/CESNET/ipfixcol2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;

  };
}

