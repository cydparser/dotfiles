switch *args:
    home-manager switch --flake ".#$(hostname)" {{args}}
