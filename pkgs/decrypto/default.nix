{
  stdenv,
  lib,
  cmake,
  wif,
  nemea-framework,
  git,
  cacert,
  libdst,
  python3,
  boost
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.numpy ]);
in
stdenv.mkDerivation rec {
  pname = "decrypto";
  version = "2.1.3";

  src = ./decrypto-main.tar;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(pkg)" "# add_subdirectory(pkg)"
  '';

  nativeBuildInputs = [ cmake git cacert ];
  buildInputs = [ wif nemea-framework libdst pythonEnv boost ];

  meta = {
    description = "NEMEA module for detection of cryptomining, based on libnemea++ and libwif.";
    homepage = "https://gitlab.liberouter.org/feta/wif-group/decrypto";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}