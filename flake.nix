{
  description = "home-manager activation";

  inputs = {
    cargo2nix = {
      url = "github:cargo2nix/cargo2nix";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-fmt = {
      url = "github:nix-community/nixpkgs-fmt";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, utils, ... }@inputs: utils.lib.eachSystem ["x86_64-linux"] (system:
    let
      rustChannel = "1.63";

      cargo2nix = (import inputs.cargo2nix {
        inherit nixpkgs rustChannel rust-overlay system;
      }).package;

      overlay = self: super: {
        inherit cargo2nix;

        ghc = self.haskell.compiler.ghc924;

        merriam-webster-1913 = self.stdenv.mkDerivation {
          name = "merriam-webster-1913";
          sourceRoot = ".";
          src = self.fetchurl {
            url = "https://s3.amazonaws.com/jsomers/dictionary.zip";
            sha256 = "09y673q5v46ps72pnm1jz0jx2bcyfbsmzw3f2x9y9s99k3yf79ps";
          };
          nativeBuildInputs = [ self.unzip ];
          installPhase = ''
            mkdir -p "$out/dic"
            tar -C "$out/dic" -xf dictionary/stardict-dictd-web1913-2.4.2.tar.bz2
          '';
        };

        nixpkgs-fmt = inputs.nixpkgs-fmt.defaultPackage.${system};

        rnix-lsp = inputs.rnix-lsp.packages.${system}.rnix-lsp;

        rust-beta = self.rust-bin.beta.latest.default;

        sdcv = self.symlinkJoin {
          name = "sdcv";
          paths = [ super.sdcv ];
          buildInputs = [ self.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/sdcv \
              --set STARDICT_DATA_DIR "${self.merriam-webster-1913}"
          '';
        };
      } // super.lib.attrsets.genAttrs [
        "cabal-fmt"
        "eventlog2html"
        "ghc-events"
        "ghc-events-analyze"
        "lentil"
        "profiteur"
        "threadscope"
      ] (name: self.haskell.lib.justStaticExecutables self.haskellPackages.${name}) ;

      homeManagerConfiguration = username: path:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            path
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                stateVersion = "22.05";
              };

              nixpkgs = {
                config.allowUnfree = true;
                config.allowUnfreePredicate = p: true;
                overlays = [ rust-overlay.overlay overlay ];
              };
            }
          ];
        };
    in
    rec {
      homeManagerConfigurations = {
        tpad = homeManagerConfiguration "cyd" config/nixpkgs/home/tpad.nix;

        wsl = homeManagerConfiguration "cyd" config/nixpkgs/home/wsl.nix;
      };

      packages = {
        tpad = homeManagerConfigurations.tpad.activationPackage;

        wsl = homeManagerConfigurations.wsl.activationPackage;
      };
    }
  );
}
