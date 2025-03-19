{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  pkg-config,
  fuse3
}:

stdenv.mkDerivation rec {
  pname = "telemetry";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "telemetry";
    tag = "v${version}";
    hash = "sha256-le9gEdG0lCBzUOcbOXi0J3Lj0JBO3MfBGjwXrtEq/oI=";
  };

  cmakeFlags = [
    "-DTELEMETRY_PACKAGE_BUILDER=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fuse3 ];


  meta = {
    description = "Library designed for the collection and processing of telemetry data.";
    homepage = "https://github.com/CESNET/telemetry";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
