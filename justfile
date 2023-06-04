switch *args:
    nix --extra-experimental-features 'nix-command flakes' build {{args}} ".#$(hostname)"
    result/activate
