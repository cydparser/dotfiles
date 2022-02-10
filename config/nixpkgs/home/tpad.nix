{ pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
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
      package = pkgs.jdk11_headless;
    };
  };
}
