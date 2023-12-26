{pkgs, ...}: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    alacritty
    androidStudioPackages.dev
  ];

  home.stateVersion = "23.11";
}
