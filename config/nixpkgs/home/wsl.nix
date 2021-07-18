{ config, pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  dotfiles = {
    fonts = false;
    gui = false;
    nixos = false;
  };

  home.packages = with pkgs; [
    wget
  ];

  targets.genericLinux.enable = true;
}
