{
  lib,
  python3,
  fetchFromGitHub,
  nemea-framework,
  pkg-config,
  pytrap,
  idea-format,
  pynspect
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pycommon";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "Nemea-Framework";
    rev = "7c3c3790c9c9345c0251d445f84ce0afd866cd0c";
    hash = "sha256-yb7vwoYHea8L3UJ8OjE3k861I7Fu8O7GOjKU4amInfg=";
  };

  sourceRoot = "${src.name}/pycommon";

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    pkg-config
  ];

  propagatedBuildInputs = [
    pytrap
    python3.pkgs.pyyaml
    python3.pkgs.ply
    python3.pkgs.jinja2
    python3.pkgs.redis
    idea-format
    pynspect
  ];

  buildInputs = [ nemea-framework ];

  meta = {
    description = "Python wrapper for TRAP interfaces";
    homepage = "https://github.com/CESNET/Nemea-Framework";
    license = lib.licenses.gpl2Plus;
  };
}


