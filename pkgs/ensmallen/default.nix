{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  armadillo
}:

stdenv.mkDerivation rec {
  pname = "ensmallen";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = "ensmallen";
    tag = "${version}";
    hash = "sha256-W7hQ28BU+d+pBvns24EBtMhK2BrPJJX/qaRKGkhxdSY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ armadillo ];

  meta = {
    description = "A header-only C++ library for numerical optimization";
    homepage = "https://github.com/mlpack/ensmallen";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}