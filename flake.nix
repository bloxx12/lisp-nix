{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "lisp-nix";
      src = ./.;
      nativeBuildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        (sbcl.withPackages (ps: with ps; [yason alexandria]))
      ];
      buildPhase = ''
        mkdir -p $out/
        ls > $out/ls
        # sbcl --script main.lisp > $out/test
      '';
    };

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        (sbcl.withPackages (ps: with ps; [yason alexandria]))
      ];
    };
  };
}
