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

      rustChannel = "1.56.0";

      cargo2nix = (import inputs.cargo2nix {
        inherit nixpkgs rustChannel rust-overlay system;
      }).package;

      overlay = self: super: {
        inherit cargo2nix;

        rnix-lsp = inputs.rnix-lsp.packages.${system}.rnix-lsp;

        rust-stable = self.rust-bin.stable."${rustChannel}".default;
      };

      homeManagerConfiguration = username: path:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;

          configuration = inputs: {
            imports = [ path ];

            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ rust-overlay.overlay overlay ];
            };
          };

          homeDirectory = "/home/${username}";
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
