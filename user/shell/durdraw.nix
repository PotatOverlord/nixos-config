# durdraw.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "durdraw";
  version = "0.29.0";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    owner = "cmang";
    repo = "durdraw";
    rev = "${version}";
    sha256 = "sha256-a+4DGWBD5XLaNAfTN/fmI/gALe76SCoWrnjyglNhVPY=";
  };

  InstallPhase = ''
    mkdir -p $out/bin
    cp durdraw.py $out/bin/durdraw
    chmod +x $out/bin/durdraw
  '';

  propagatedBuildInputs = with pkgs.python3Packages; [
    pillow
    setuptools
  ];

  doCheck = false;

/*  meta = with lib; {
    homepage = "";
    description = "";
    license = licenses.bsd3;
    maintainers = with maintainers; []; 
  }; */
}
