{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  gnumake,
  autoconf,
  libtool,
  libxml2,
  automake,
  pkg-config,
  bison,
  flex,
  libidn,
  bash,
  nemea-framework,
  python3,
  lua,
  pytrap,
  pycommon
}:

let
  pythonEnv = python3.withPackages (ps: [ pytrap pycommon ]);
in
stdenv.mkDerivation rec {
  pname = "Nemea Modules";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Nemea-Modules";
    rev = "5a9e20fd8b405123486a5520c56f3d3768798a6a";
    hash = "sha256-73CJFkD0sKhg43Pc9v3BpAIWS0Zqbe1XL9TjPRzzpvk=";
  };

  configurePhase = ''
    autoreconf -i
    ./configure CFLAGS="-Wno-error=int-conversion" --prefix=$out
  '';

  buildInputs = [ autoconf libtool libxml2 automake gnumake pkg-config bash bison flex libidn lua nemea-framework pythonEnv ];

  meta = {
    description = "NEMEA Modules";
    homepage = "https://github.com/CESNET/Nemea-Modules";
  };
}
