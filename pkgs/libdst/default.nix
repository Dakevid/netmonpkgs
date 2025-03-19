{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  git,
  cacert
}:

stdenv.mkDerivation rec {
  pname = "libdst";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "AjayOommen";
    repo = "LIBDST";
    rev = "42c4ef4c8a639a0de82a8b0c66dbe7e67de919ea";
    hash = "sha256-q01k2R5BR7aPe8zFZW/N3CV+sf1P6+czhh9YjDh0XY8=";
  };

  cmakeFlags = [
    "-DDSTLIB_PACKAGE_BUILDER=OFF"
  ];

  nativeBuildInputs = [ cmake git cacert ];
  buildInputs = [ ];


  meta = {
    description = "Library implementation of Dempster-Shafer Theory.";
    homepage = "https://github.com/AjayOommen/LIBDST";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}