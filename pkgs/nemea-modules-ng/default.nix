{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  nemea-framework,
  python3,
  pkg-config,
  ncurses,
  git,
  cacert,
  fuse3,
  boost,
  libmaxminddb,
  pytrap,
  pycommon
}:

let
  pythonEnv = python3.withPackages (ps: [ pytrap pycommon ]);
in
stdenv.mkDerivation rec {
  pname = "Nemea Modules NG";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "nemea-modules-ng";
    rev = "11b2efec8f37bcb6049c318f2e3132cf6ce9f59c";
    hash = "sha256-MC7ukHQyOLexsRC5o6U9wRoLGUhNH+1iG58zNfqPAT0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "add_subdirectory(pkg)" "# add_subdirectory(pkg)"
    substituteInPlace ./cmake/installation.cmake --replace-fail 'set(INSTALL_DIR_BIN "''${CMAKE_INSTALL_FULL_BINDIR}/nemea")' 'set(INSTALL_DIR_BIN "''${CMAKE_INSTALL_FULL_BINDIR}")'
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_FULL_BINDIR=$out/bin"
  ];

  nativeBuildInputs = [ cmake pkg-config git cacert ];
  buildInputs = [ nemea-framework pythonEnv ncurses fuse3 boost libmaxminddb ];

  meta = {
    description = "NEMEA Modules NG";
    homepage = "https://github.com/CESNET/nemea-modules-ng";
  };
}
