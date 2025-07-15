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
  fetchPypi
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

  pythonEnv = python3.withPackages (ps: [ nemea-pytrap ]);
in
stdenv.mkDerivation rec {
  pname = "Nemea Modules";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Nemea-Modules";
    rev = "320a875b11a4d23600d122a37360112719044793";
    hash = "sha256-Ia3fB2WNN8OS1XssSQzxxGB7sRad4D6QUVDd0PYzXow=";
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
