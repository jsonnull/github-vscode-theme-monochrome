{
  description = "Monochrome GitHub VSCode Themes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_22;

        package = pkgs.callPackage ./yarn-project.nix { inherit nodejs; } {
          src = ./.;
          overrideAttrs = old: {
            buildPhase = "yarn build";
          };
        };

      in
      {
        packages.default = package;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            git
            yarn-berry
          ];
        };
      }
    );
}
