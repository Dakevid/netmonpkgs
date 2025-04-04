{
  stdenv,
  lib,
  cmake,
  wif,
  nemea-framework,
  git,
  cacert,
  libdst,
  boost,
  fetchPypi,
  python3
}:

let
  nemea-pytrap = python3.pkgs.buildPythonPackage rec {
    pname = "nemea-pytrap";
    version = "0.17.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Bpst1oU9ZbODgpF0oayjfT20wiheoG3HiLRWYyaqPa8=";
    };
    propagatedBuildInputs = with python3.pkgs; [ setuptools nemea-framework ];
  };

  pythonEnv = python3.withPackages (ps: [
    nemea-pytrap
    ps.numpy
    ps.xxhash
    ps.scikit-learn
  ]);
in
stdenv.mkDerivation rec {
  pname = "decrypto";
  version = "2.1.3";

  src = ./decrypto-main.tar;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "add_subdirectory(pkg)" "# add_subdirectory(pkg)"
  '';

  nativeBuildInputs = [ cmake git cacert ];
  buildInputs = [ wif nemea-framework libdst pythonEnv boost ];

  postInstall = ''
    tar -xvf $src -C $TMPDIR
    cp -r $TMPDIR/decrypto-main/aggregator $out/bin/
    cp -r $TMPDIR/decrypto-main/extras $out/bin/decryto_extras
    ln -s ${pythonEnv} $out/bin/python-decrypto
  '';

  meta = {
    description = "NEMEA module for detection of cryptomining, based on libnemea++ and libwif.";
    homepage = "https://gitlab.liberouter.org/feta/wif-group/decrypto";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}