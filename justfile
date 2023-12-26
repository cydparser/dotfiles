switch *args:
    home-manager switch --flake ".#$(hostname)" {{args}}

news:
    home-manager news --flake ".#$(hostname)"
