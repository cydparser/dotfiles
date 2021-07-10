{ ... }: {
  imports = [
    ./configuration.nix
  ];

  home.packages = with pkgs; [
    hpack
  ];
}
