{ pkgs, ... }: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    androidStudioPackages.dev
    hpack
    jetbrains.idea-community
    postman
    slack
    zoom-us
  ];
}
