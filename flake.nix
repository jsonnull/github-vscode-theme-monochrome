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

        extName = "github-vscode-theme-monochrome";
        extVersion = "0.0.1";
        extPublisher = "jsonnull";

        extVsix = pkgs.callPackage ./yarn-project.nix { inherit nodejs; } {
          src = ./.;

          overrideAttrs = old: {
            buildPhase = ''
              yarn build
              ${pkgs.vsce}/bin/vsce package -o ${extName}-${extVersion}.zip --no-dependencies
            '';

            installPhase = ''
              mkdir -p $out/share/vscode/extensions
              mv ${extName}-${extVersion}.zip $out/share/vscode/extensions
            '';
          };
        };

        package = pkgs.vscode-utils.buildVscodeExtension {
          name = extName;
          pname = extName;
          version = extVersion;
          publisher = extPublisher;
          src = "${extVsix}/share/vscode/extensions/${extName}-${extVersion}.zip";
          vscodeExtPublisher = extPublisher;
          vscodeExtName = extName;
          vscodeExtUniqueId = "${extPublisher}.${extName}";
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
