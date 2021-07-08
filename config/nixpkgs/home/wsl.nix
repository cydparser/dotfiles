{ config, pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  dotfiles = {
    fonts = false;
    gui = false;
    nixos = false;
  };

  targets.genericLinux.enable = true;
}
