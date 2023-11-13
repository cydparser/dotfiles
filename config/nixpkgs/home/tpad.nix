{pkgs, ...}: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    alacritty
    androidStudioPackages.dev
    google-java-format
    slack
    zoom-us
  ];

  stateVersion = "22.05";

  programs = {
    java = {
      enable = true;
      package = pkgs.openjdk17_headless;
    };
  };
}
