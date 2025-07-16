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
    propagatedBuildInputs = with python3.pkgs; [ setuptools nemea-framework geoip2 ];
  };

  pythonEnv = python3.withPackages (ps: [ nemea-pytrap ]);
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
