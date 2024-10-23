{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;

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
  in {
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        (sbcl.withPackages (ps: with ps; [yason alexandria]))
      ];
    };

    nixosConfigurations."test" = nixpkgs.legacyPackages.x86_64-linux.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        jeson
      ];
    };
  };
}
