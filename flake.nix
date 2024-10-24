{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    to-json = pkgs.stdenv.mkDerivation {
      name = "cl-to-json";
      src = ./.;
      nativeBuildInputs = with pkgs; [
        (sbcl.withPackages (ps: with ps; [yason alexandria]))
      ];
      buildPhase = ''
        sbcl --script main.lisp > $out
      '';
    };
    jeson = builtins.fromJSON (builtins.toString (builtins.readFile to-json));
  in {
    packages.x86_64-linux.default = to-json;

    devShells = forEachSystem (
      system: {
        default = pkgsForEach.${system}.mkShell {
          buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
            (sbcl.withPackages (ps: with ps; [yason alexandria]))
          ];
        };
      }
    );
    nixosConfigurations."test" = nixpkgs.legacyPackages.x86_64-linux.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        jeson
      ];
    };
  };
}
