{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  nemea-framework,
  cmake,
  git,
  cacert,
  python3,
  fetchPypi,
  boost
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.numpy ]);
in
stdenv.mkDerivation rec {
  pname = "wif";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "wif";
    tag = "v${version}";
    hash = "sha256-JiXv67swf4+QNsIpalLqFLyteRFy/wf9LS2kNQaFYCs=";
  };

  cmakeFlags = [
    "-DBUILD_WITH_UNIREC=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(pkg)" "# add_subdirectory(pkg)"
  '';

  nativeBuildInputs = [ cmake git cacert boost ];
  buildInputs = [ nemea-framework pythonEnv];


  meta = {
    description = "Library for fast development of (heterogeneous) detection and classification modules for (Encrypted) Network Traffic Analysis.";
    homepage = "https://github.com/CESNET/wif";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}