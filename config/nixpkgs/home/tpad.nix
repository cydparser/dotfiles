{ pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    androidStudioPackages.dev
    hpack
    jdk11_headless
    jetbrains.idea-community
    maven
    postman
    slack
    zoom-us
  ];
}
