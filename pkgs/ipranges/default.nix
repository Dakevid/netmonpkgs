{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "ipranges";
  version = "0.1.13";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-OMU9Vi+utHjYYQK2pQsOVvB05CHB7Haud4hAGQ9Xli0=";
  };
}
