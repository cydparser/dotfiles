{
  description = "home-manager activation";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
  }: let
    systems =
      if builtins.hasAttr "currentSystem" builtins
      then [builtins.currentSystem]
      else
        with flake-utils.lib; [
          system.aarch64-darwin
          system.aarch64-linux
          system.x86_64-darwin
          system.x86_64-linux
        ];

    nixosHosts = [
      "tpad"
      "wsl"
    ];

    home-manager-module = host: {
      home-manager = {
        verbose = true;
        # Install packages to /etc/profiles; needed to run `nixos-rebuild build-vm`.
        useUserPackages = true;
        useGlobalPkgs = true;
        users.${username} = import config/home-manager/${host}.nix;
      };
    };

    overlay = self: super:
      {
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

        sdcv = self.symlinkJoin {
          name = "sdcv";
          paths = [super.sdcv];
          buildInputs = [self.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/sdcv \
              --set STARDICT_DATA_DIR "${self.merriam-webster-1913}"
          '';
        };

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

    username = "cyd";
  in
    flake-utils.lib.eachSystem systems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [overlay];
        };

        lib = pkgs.lib;

        homeManagerConfiguration = path:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [path];
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
          # Installed via `home-manager switch --flake ".#HOSTNAME"`
          homeConfigurations =
            lib.attrsets.genAttrs nixosHosts (host:
              homeManagerConfiguration config/home-manager/${host}.nix);
        };
      }
    )
    // {
      darwinModules =
        nixpkgs.lib.attrsets.genAttrs ["ts"] home-manager-module;

      nixosModules =
        nixpkgs.lib.attrsets.genAttrs nixosHosts home-manager-module;

      overlays = {
        default = overlay;
      };
    };
}
