{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  libxml2,
  lz4,
  zstd
}:

stdenv.mkDerivation rec {
  pname = "libfds";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libfds";
    tag = "v${version}";
    hash = "sha256-rYEUjMnKPxE0HxPZZ58DwrhPb89NpIjEnftqbsfkvTU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libxml2 lz4 zstd ];


  meta = {
    description = "The library provides components for parsing and processing IPFIX Messages.";
    homepage = "https://github.com/CESNET/libfds";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}