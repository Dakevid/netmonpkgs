{ lib, python3, ipranges, typedcols }:

python3.pkgs.buildPythonPackage rec {
  pname = "idea-format";
  version = "0.1.15";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-0gehoZBjB2s3JkQGYbs+A6BhT1vf6eCFEbyhdidn0BU=";
  };

  propagatedBuildInputs = [ ipranges typedcols ];
}
