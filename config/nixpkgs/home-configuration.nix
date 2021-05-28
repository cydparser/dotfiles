{ config, lib, pkgs, ... }:

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

  home.packages = with pkgs; [
    bat
    cabal-install
    cabal2nix
    cachix
    diffutils
    git
    gitAndTools.delta
    gnupg
    haskell.compilers.ghc8104
    jq
    k2pdfopt
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
  ] ++ optional config.dotfiles.gui [
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

  home.file = {
    ".Xresources".source = ./Xresources;
    ".bash_profile".source = ./bash_profile;
    ".bashrc".source = ./bashrc;
    ".gemrc".source = ./gemrc;
    ".ghci".source = ./ghci;
    ".gtkrc-2.0".source = ./gtkrc-2.0;
    ".haskeline".source = ./haskeline;
    ".irbrc".source = ./irbrc;
    ".pryrc".source = ./pryrc;
    ".stylish-haskell.yaml".source = ./.stylish-haskell.yaml;
    ".vimrc".source = ./vimrc;
    ".xinitrc".source = ./xinitrc;
    ".zshenv".source = ./zshenv;

    ".config" = {
      Code.User."settings.json".source = config/Code/User/settings.json;

      autostart = {
      } // lib.optionalAttrs config.dotfiles.nixos
        (let
          etc = "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart";

          fileSource = f: {
            name = f;
            value = {
              source = builtins.replaceStrings ["OnlyShowIn"] ["#OnlyShowIn"]
                (builtins.readFile "${etc}/${f}");
            };
          };
        in
          builtins.listToAttrs
            (builtins.map fileSource
              (builtins.filter (f: builtins.isList (builtins.match ".+\.desktop$" f))
                (builtins.attrNames (builtins.readDir etc)))));

      brittany."config.yaml" = config/brittany/config.yaml;

      direnv."direnv.toml" = config/direnv/direnv.toml;

      "gtk-3.0"."settings.ini" = config/gtk-3.0/settings.ini;

      hunspell.en_US = config/hunspell/en_US;

      ispell.words = config/ispell/words;

      git = {
        recursive = true;
        source = config/git;
      };

      nix."nix.conf" = config/nix/nix.conf;

      nixpkgs = {
        recursive = true;
        source = config/nixpkgs;
      };

      profile = {
        recursive = true;
        source = config/profile;
      };

      readline.inputrc = config/readline/inputrc;

      termite.config = config/termite/config;

      tmux.conf = config/tmux/conf;

      xmobar.xmobarrc = config/xmobar/xmobarrc;

      xmonad = {
        recursive = true;
        source = config/xmonad;
      };

      zsh.".zshrc" = config/zsh/.zshrc;
    };

    ".local" = {
      bin = {
        recursive = true;
        source = local/bin;
      };
    };

  programs = {
    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
  };

}
