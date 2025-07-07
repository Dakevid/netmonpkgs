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
    rev = "d4f4969c18936e6a9613f2c29f5f720bc69960de";
    hash = "sha256-S30vjWItPQvw6NJm64upC/ydkzjefMuGpUsSSBHnbz4=";
  };

  configurePhase = ''
    autoreconf -i
    ./configure CFLAGS="-Wno-error=int-conversion" --prefix=$out
  '';

  buildInputs = [ autoconf libtool libxml2 automake gnumake pkg-config bash bison flex libidn nemea-framework pythonEnv ];

  meta = {
    description = "NEMEA Modules";
    homepage = "https://github.com/CESNET/Nemea-Modules";
  };
}
