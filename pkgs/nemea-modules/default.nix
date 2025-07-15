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
    rev = "c475786fe174b765ab37595dc91aea6317f05ccd";
    hash = "sha256-5Kd4B60whQNjlzWOBN7jPbWo/eA4m7fbRajbqqXwb80=";
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
