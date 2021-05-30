{ config, lib, pkgs, ... }:
let
  cfg = config.dotfiles;

  inherit (pkgs.haskellPackages) ghc lentil steeloverseer;

  dir = ../..;
in
with lib;
{
  options = {
    dotfiles = {
      gui = mkOption {
        type    = types.bool;
        default = true;
      };

      nixos = mkOption {
        type    = types.bool;
        default = true;
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      bat
      cabal-install
      cabal2nix
      cachix
      diffutils
      git
      gitAndTools.delta
      gnupg
      ghc
      jq
      # k2pdfopt (insecure)
      lentil
      lld
      nix-prefetch-git
      python3
      python38Packages.sphinx
      ripgrep
      shellcheck
      steeloverseer
      tree
      unzip
      zsh
    ] ++ optional cfg.gui [
      firefox-bin
      google-chrome
      inkscape
      krita
      obs-studio
      signal-desktop
      spotify
      vlc
      vscode
    ];

    fonts.fontconfig.enable = true;

    home.file =
      let
        mkFile = f: paths: builtins.listToAttrs
          (builtins.map
            (path: let foo = {
              name = "." + path;
              value = f {
                source = dir + ("/" + path);
              };
            };
            in 
            builtins.trace (builtins.deepSeq foo foo) foo)
            paths
          );
      in
        (mkFile (x: x) [
          "bash_profile"
          "bashrc"
          "config/brittany/config.yaml"
          "config/Code/User/settings.json"
          "config/direnv/direnv.toml"
          #"config/git/config"
          #"config/git/ignore"
          "config/gnupg/gpg-agent.conf"
          "config/gtk-3.0/settings.ini"
          "config/hunspell/en_US"
          "config/ispell/words"
          "config/nix/nix.conf"
          #"config/nixpkgs/config.nix"
          #"config/nixpkgs/home-configuration.nix"
          #"config/nixpkgs/overlays/misc-overlay.nix"
          #"config/nixpkgs/overlays/texlive-overlay.nix"
          #"config/profile/aws"
          #"config/profile/darwin"
          #"config/profile/docker"
          #"config/profile/general"
          #"config/profile/haskell"
          #"config/profile/nix"
          "config/readline/inputrc"
          "config/termite/config"
          "config/tmux/conf"
          "config/xmobar/xmobarrc"
          #"config/xmonad/Build.hs"
          #"config/xmonad/default.nix"
          #"config/xmonad/.gitignore"
          #"config/xmonad/Setup.hs"
          #"config/xmonad/shell.nix"
          #"config/xmonad/src/Main.hs"
          #"config/xmonad/xmonad-config.cabal"
          #"config/xmonad/xmonad.hs"
          "config/zsh/.zshrc"
          "gemrc"
          "ghci"
          ".gitignore"
          "gtkrc-2.0"
          "haskeline"
          "install.sh"
          "irbrc"
          #"local/bin/nx"
          #"local/bin/nx-shake"
          "pryrc"
          "stylish-haskell.yaml"
          "vimrc"
          "xinitrc"
          "Xresources"
          "zshenv"
        ])
        // (mkFile (attrs: attrs // { recursive = true; })
          [
            "config/git"
            "config/nixpkgs"
            "config/profile"
            "config/xmonad"
            "local/bin"
          ])
        // lib.optionalAttrs cfg.nixos
          (let
            etc = "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart";

            fileText = filename: {
              name = ".config/autostart/${filename}";
              value = {
                text = builtins.replaceStrings ["OnlyShowIn"] ["#OnlyShowIn"]
                  (builtins.readFile "${etc}/${filename}");
              };
            };
          in
            builtins.listToAttrs
              (builtins.map fileText
                (builtins.filter (filename: builtins.isList (builtins.match ".+\.desktop$" filename))
                  (builtins.attrNames (builtins.readDir etc)))));

    programs = {
      home-manager = {
        enable = true;
      };

      direnv = {
        enable = true;
        enableNixDirenvIntegration = true;
      };
    };

    services = {
      lorri.enable = true;
    };
  };
}
