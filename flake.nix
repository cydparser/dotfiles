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
      pkgs = nixpkgs.legacyPackages.${system};

      rustChannel = "1.59.0";

      cargo2nix = (import inputs.cargo2nix {
        inherit nixpkgs rustChannel rust-overlay system;
      }).package;

      overlay = self: super: {
        inherit cargo2nix;

        nixpkgs-fmt = inputs.nixpkgs-fmt.defaultPackage.${system};

        rnix-lsp = inputs.rnix-lsp.packages.${system}.rnix-lsp;

        rust-beta = self.rust-bin.beta.latest.default;
      };

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
