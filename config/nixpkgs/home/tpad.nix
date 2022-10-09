{ pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    alacritty
    androidStudioPackages.dev
    jetbrains.idea-community
    maven
    postman
    slack
    zoom-us
  ];

  programs = {
    java = {
      enable = true;
      package = pkgs.openjdk17_headless;
    };
  };
}
