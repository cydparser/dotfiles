{
  description = "home-manager activation";

  inputs = {
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.fenix.follows = "fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nurl = {
      url = "github:nix-community/nurl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    statix = {
      url = "github:nerdypepper/statix";
      inputs.fenix.follows = "fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    rust-overlay,
    utils,
    ...
  } @ inputs:
    utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        overlay = self: super:
          {
            alejandra = inputs.alejandra.packages.${system}.default;

            ghc = self.haskell.compiler.ghc96;

            merriam-webster-1913 = self.stdenv.mkDerivation {
              name = "merriam-webster-1913";
              sourceRoot = ".";
              src = self.fetchurl {
                url = "https://s3.amazonaws.com/jsomers/dictionary.zip";
                sha256 = "09y673q5v46ps72pnm1jz0jx2bcyfbsmzw3f2x9y9s99k3yf79ps";
              };
              nativeBuildInputs = [self.unzip];
              installPhase = ''
                mkdir -p "$out/dic"
                tar -C "$out/dic" -xf dictionary/stardict-dictd-web1913-2.4.2.tar.bz2
              '';
            };

            nurl = inputs.nurl.packages.${system}.default;

            rust-beta = self.rust-bin.beta.latest.default;

            sdcv = self.symlinkJoin {
              name = "sdcv";
              paths = [super.sdcv];
              buildInputs = [self.makeWrapper];
              postBuild = ''
                wrapProgram $out/bin/sdcv \
                  --set STARDICT_DATA_DIR "${self.merriam-webster-1913}"
              '';
            };

            statix = inputs.statix.packages.${system}.statix;

            xmllint = self.libxml2;
          }
          // super.lib.attrsets.genAttrs [
            "cabal-fmt"
            "eventlog2html"
            "ghc-events"
            "ghc-events-analyze"
            "lentil"
            "profiteur"
            "stylish-haskell"
            "threadscope"
          ] (name: self.haskell.lib.justStaticExecutables self.haskellPackages.${name});

        pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlay overlay];
        };

        homeManagerConfiguration = username: path:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [path];
            specialArgs = {inherit username;};
          };
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              just
            ];

            shellHook = ''
              scripts/init
            '';
          };
        };

        packages = {
          homeManagerConfigurations = {
            tpad = homeManagerConfiguration "cyd" config/nixpkgs/home/tpad.nix;

            wsl = homeManagerConfiguration "cyd" config/nixpkgs/home/wsl.nix;
          };
        };
      }
    );
}
