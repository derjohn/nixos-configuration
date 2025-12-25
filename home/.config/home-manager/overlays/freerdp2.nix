final: prev:

let
  oldpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.05.tar.gz";
    sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
  }) {
    system = prev.system;
  };
in {
  # freerdp2pkg = oldpkgs.freerdp;

  freerdp2 = final.writeShellScriptBin "xfreerdp2" ''
    exec ${oldpkgs.freerdp}/bin/xfreerdp "$@"
  '';
}

