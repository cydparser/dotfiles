{
  description = "home-manager activation";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };

  outputs = { self, nixpkgs, home-manager, rnix-lsp }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      overlay = self: super: {
        rnix-lsp = rnix-lsp.packages.${system}.rnix-lsp;
      };

      homeManagerConfiguration = username: path:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;

          configuration = inputs: {
            imports = [ path ];

            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ overlay ];
            };
          };

          homeDirectory = "/home/${username}";
        };
    in
    {
      homeManagerConfigurations = {
        tpad = homeManagerConfiguration "cyd" config/nixpkgs/home/tpad.nix;

        wsl = homeManagerConfiguration "cyd" config/nixpkgs/home/wsl.nix;
      };

      tpad = self.homeManagerConfigurations.tpad.activationPackage;

      wsl = self.homeManagerConfigurations.wsl.activationPackage;
    };
}
