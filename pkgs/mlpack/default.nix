{
  stdenv,
  lib,
  fetchFromGitHub ? lib.fetchFromGitHub,
  cmake,
  armadillo,
  ensmallen,
  cereal,
  pkg-config,
  git
}:

stdenv.mkDerivation rec {
  pname = "mlpack";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "mlpack";
    repo = "mlpack";
    tag = "${version}";
    hash = "sha256-HtxwUck9whHg/YLKJVJkNsh4zLIu6b0a+NeKICmB7uk=";
  };

  nativeBuildInputs = [ cmake pkg-config git ];
  buildInputs = [ armadillo ensmallen cereal ];

  meta = {
    description = "mlpack: a fast, header-only C++ machine learning library";
    homepage = "https://github.com/mlpack/mlpack";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}