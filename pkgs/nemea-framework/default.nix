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
    rev = "7c3c3790c9c9345c0251d445f84ce0afd866cd0c";
    hash = "sha256-yb7vwoYHea8L3UJ8OjE3k861I7Fu8O7GOjKU4amInfg=";
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
