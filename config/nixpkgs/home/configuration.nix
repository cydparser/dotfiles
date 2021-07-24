{ config, lib, pkgs, ... }:
let
  cfg = config.dotfiles;

  inherit (pkgs.haskellPackages) cabal-fmt ghc lentil steeloverseer;

  dir = ../../..;

    emacs-plus =
      let
        emacs =
          if cfg.gui
          then pkgs.emacs.override { webkitgtk = pkgs.webkitgtk; withXwidgets = true; }
          else pkgs.emacs;
      in
        (pkgs.emacsPackagesFor emacs).emacsWithPackages (epkgs: with epkgs.melpaStablePackages; [
          pdf-tools
        ]);

  iosevka-with = name: f: pkgs.iosevka.override {
    set = name;
    privateBuildPlan = builtins.readFile f;
  };

  ripgrepWithPCRE2 = pkgs.ripgrep.override { withPCRE2 = true; };
in
with lib;
{
  options = {
    dotfiles = {
      fonts = mkOption {
        type    = types.bool;
        default = true;
      };

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
      cabal-fmt
      cabal-install
      cabal2nix
      cachix
      diffutils
      emacs-plus
      git
      git-lfs
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
      ripgrepWithPCRE2
      rnix-lsp
      shellcheck
      steeloverseer
      tree
      unzip
      zsh
    ] ++ optionals cfg.fonts [
      symbola

      (nerdfonts.override {
        fonts = [
          "Iosevka"
        ] ++ optionals cfg.gui [
          "CascadiaCode"
          "Hasklig"
        ];
      })
    ] ++ optionals cfg.gui [
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
            (path: {
              name = "." + path;
              value = f {
                source = dir + ("/" + path);
              };
            })
            paths
          );
      in
        (mkFile (x: x) [
          "bash_profile"
          "bashrc"
          "config/brittany/config.yaml"
          # "config/Code/User/settings.json" (synced)
          "config/direnv/direnv.toml"
          "config/gnupg/gpg-agent.conf"
          "config/gtk-3.0/settings.ini"
          "config/hunspell/en_US"
          "config/ispell/words"
          "config/nix/nix.conf"
          "config/readline/inputrc"
          "config/termite/config"
          "config/tmux/conf"
          "config/xmobar/xmobarrc"
          "config/zsh/.zshrc"
          "gemrc"
          "ghci"
          ".gitignore"
          "gtkrc-2.0"
          "haskeline"
          "irbrc"
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

        nix-direnv = {
          enable = true;
          enableFlakes = true;
        };
      };

      lsd = {
        enable = true;
      };
    };

    services = {
      lorri.enable = true;
    };
  };
}
