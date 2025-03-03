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
  bash
}:

stdenv.mkDerivation rec {
  pname = "Nemea-Framework";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Nemea-Framework";
    rev = "7031b1cf1cb9a0f650f05ed335cf7be6f67935ca";
    hash = "sha256-Yz/ugcVzs1WnYrMHaXDsJkWJOM0qhGUV2yy3yjvC8oU=";
  };

  postPatch = ''
    patchShebangs .
  '';

  configurePhase = ''
    autoreconf -i
    ./configure --prefix=$out
  '';

  nativeBuildInputs = [ autoconf libtool automake gnumake pkg-config bash ];
  buildInputs = [ libxml2 ];

  meta = {
    description = "Base libraries for Nemea system which is a modular system that consists of independent modules for network traffic analysis and anomaly detection.";
    homepage = "https://github.com/CESNET/Nemea-Framework";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}