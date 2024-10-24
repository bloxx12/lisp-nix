let
  pkgs = import <nixpkgs>;
  systems = ["x86_64-linux" "aarch64-linux"];
  forEachSystem = pkgs.lib.genAttrs systems;
  pkgsForEach = pkgs.legacyPackages;
  to-json = forEachSystem (system:
    pkgsForEach.${system}.stdenv.mkDerivation {
      name = "cl-to-json";
      src = ./.;
      nativeBuildInputs = with pkgsForEach.${system}; [
        (sbcl.withPackages (ps: with ps; [yason alexandria]))
      ];
      buildPhase = ''
        sbcl --script main.lisp > $out
      '';
    });
  jeson = builtins.fromJSON (builtins.toString (builtins.readFile to-json));
in
  pkgs.testers.runNixOSTest {
    name = "test-nix";
    nodes = {
      machine1 = {
        config,
        pkgs,
        ...
      }:
        jeson;
    };
    testScript = {nodes, ...}: ''
      # ...
    '';
  }
