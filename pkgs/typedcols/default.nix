{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "typedcols";
  version = "0.1.15";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-TZRgQASLoSJudEkGJtJXMjQC3m8CJogdddNyh+/QpFM=";
  };

  meta = with lib; {
    description = "Library for typed collections";
    homepage = "https://github.com/CESNET/typedcols";
    license = licenses.mit;
  };
}
