{
  lib,
  python3,
  fetchFromGitHub,
  nemea-framework,
  pkg-config
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pytrap";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Nemea-Framework";
    rev = "7c3c3790c9c9345c0251d445f84ce0afd866cd0c";
    hash = "sha256-yb7vwoYHea8L3UJ8OjE3k861I7Fu8O7GOjKU4amInfg=";
  };

  sourceRoot = "${src.name}/pytrap";

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    pkg-config
  ];

  buildInputs = [ nemea-framework ];

  meta = {
    description = "Python wrapper for TRAP interfaces";
    homepage = "https://github.com/CESNET/Nemea-Framework";
    license = lib.licenses.gpl2Plus;
  };
}


