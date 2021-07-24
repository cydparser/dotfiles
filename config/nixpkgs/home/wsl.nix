{ config, pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  dotfiles = {
    fonts = false;
    gui = false;
    systemd = false;
  };

  home.packages = with pkgs; [
    wget
  ];

  targets.genericLinux.enable = true;
}
