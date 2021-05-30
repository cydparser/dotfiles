{ config, pkgs, ... }: {
  imports = [
    ./home-configuration.nix
  ];

  dotfiles = {
    gui = false;
    nixos = false;
  };

  targets.genericLinux.enable = true;
}
