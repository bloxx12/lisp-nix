all:
	@nix build
	@nix eval --expr 'builtins.fromJSON (builtins.readFile ./result)' --impure > .result
	@cat .result
