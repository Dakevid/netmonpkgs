{ lib, python3, ipranges }:

python3.pkgs.buildPythonPackage rec {
  pname = "pynspect";
  version = "0.22";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-Yjgzbv19/qi87twvGKvxeqSFBdaXWWn2ubO1NQQs6JM=";
  };

  propagatedBuildInputs = [
    ipranges
    python3.pkgs.ply
    python3.pkgs.six
  ];

  meta = with lib; {
    description = "Python data inspection library";
    homepage = "https://github.com/honzamach/pynspect";
    license = licenses.mit;
  };
}
