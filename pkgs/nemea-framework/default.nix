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
    rev = "66562ae0498ef533969cc8cd464ffcf644cfe17d";
    hash = "sha256-O+cDbvXVXHhNdEolirMgx4b3+TBlrVkbrpyw0qiuwZE=";
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
