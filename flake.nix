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
    in
    {
      homeManagerConfigurations = {
        wsl = home-manager.lib.homeManagerConfiguration {
          inherit system;

          configuration = { lib, pkgs, ... }: {
            imports = [ config/nixpkgs/home/wsl.nix ];

            home.packages = with pkgs; [
              rnix-lsp.packages.${system}.rnix-lsp
              wget
            ];
          };

          homeDirectory = "/home/cyd";
          username = "cyd";
        };
      };

      wsl = self.homeManagerConfigurations.wsl.activationPackage;
    };
}
