{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles;

  bool = b:
    lib.mkOption {
      type = lib.types.bool;
      default = b;
    };

  dir = ../../..;

  emacs-plus = let
    emacs = pkgs.emacs29.override {
      withPgtk = cfg.wayland;
    };
  in
    (pkgs.emacsPackagesFor emacs).withPackages (epkgs:
      with epkgs.melpaPackages; [
        pdf-tools
        epkgs.treesit-grammars.with-all-grammars
        vterm
      ]);

  ripgrepWithPCRE2 = pkgs.ripgrep.override {withPCRE2 = true;};
in
  with lib; {
    options = {
      dotfiles = {
        dev = {
          haskell = bool true;
          nix = bool true;
          reStructuredText = bool true;
          rust = bool false;
          toml = bool true;
        };

        fonts = bool true;
        gui = bool true;
        lexical = bool true;
        systemd = bool true;
        wayland = bool false;
      };
    };

    config = {
      home.packages = with pkgs;
        [
          bat
          bottom
          cachix
          cask
          difftastic
          diffutils
          du-dust
          duf
          emacs-plus
          fd
          git-filter-repo
          git-lfs
          gitAndTools.delta
          gitFull
          gnumake
          gnupg
          hyperfine
          jq
          just
          # k2pdfopt (insecure)
          lentil
          lld
          nix-prefetch-git
          nixUnstable
          nurl
          nushell
          procs
          shellcheck
          silver-searcher
          starship
          tokei
          topiary # tree-sitter formatter
          tree
          unzip
          xmllint
          yaml-language-server
          zsh
        ]
        ++ optionals cfg.dev.haskell [
          cabal-fmt
          cabal-install
          cabal2nix
          eventlog2html
          ghc
          ghc-events
          # ghc-events-analyze (broken)
          # profiteur (broken)
          stylish-haskell
          # threadscope (broken)
          z3
        ]
        ++ optionals cfg.lexical [
          espeak
          hunspell
          sdcv
          wordnet
        ]
        ++ optionals cfg.dev.nix [
          alejandra
          nil
          nickel
          patchelf
          statix
        ]
        ++ optionals cfg.dev.reStructuredText [
          python3
          python38Packages.sphinx
        ]
        ++ optionals cfg.dev.rust [
          # Needed to avoid error: `linker cc not found`
          gcc
          rust-analyzer
          rust-beta
        ]
        ++ optionals (cfg.dev.toml || cfg.dev.rust) [
          taplo-lsp
        ]
        ++ optionals cfg.fonts [
          symbola

          (nerdfonts.override {
            fonts =
              [
                "IosevkaTerm"
                "Inconsolata"
              ]
              ++ optionals cfg.gui [
                "CascadiaCode"
                "Hasklig"
              ];
          })
        ]
        ++ optionals cfg.gui [
          firefox-bin
          graphicsmagick
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

      home.file = let
        mkFile = f: paths:
          builtins.listToAttrs
          (
            builtins.map
            (path: {
              name = "." + path;
              value = f {
                source = dir + ("/" + path);
              };
            })
            paths
          );
      in
        lib.optionalAttrs cfg.lexical {
          "Library/Spelling".source = "${pkgs.hunspellDicts.en-us}/share/hunspell";
        }
        // (mkFile (x: x) [
          "bash_profile"
          "bashrc"
          "cargo/config.toml"
          "config/alacritty/alacritty.yml"
          "config/bat/config"
          "config/brittany/config.yaml"
          # "config/Code/User/settings.json" (synced)
          "config/direnv/direnv.toml"
          "config/fourmolu.yaml"
          "config/gnupg/gpg-agent.conf"
          "config/gtk-3.0/settings.ini"
          "config/ispell/words"
          "config/nix/nix.conf"
          "config/psql/psqlrc"
          "config/readline/inputrc"
          "config/stylish-haskell/config.yaml"
          "config/termite/config"
          "config/tmux/conf"
          "config/xmobar/xmobarrc"
          "config/zsh/.zshrc"
          "gemrc"
          "ghci"
          "gtkrc-2.0"
          "haskeline"
          "irbrc"
          "pryrc"
          "vimrc"
          "xinitrc"
          "Xresources"
          "zshenv"
        ])
        // (mkFile (attrs: attrs // {recursive = true;})
          [
            "config/git"
            "config/nixpkgs"
            "config/profile"
            "config/xmonad"
            "local/bin"
          ])
        // lib.optionalAttrs cfg.systemd
        (let
          etc = "${pkgs.gnome.gnome-keyring}/etc/xdg/autostart";

          fileText = filename: {
            name = ".config/autostart/${filename}";
            value = {
              text =
                builtins.replaceStrings ["OnlyShowIn"] ["#OnlyShowIn"]
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
          };
        };

        fzf = let
          fd = "${pkgs.fd}/bin/fd";
        in {
          enable = true;
          changeDirWidgetCommand = "${fd} --type d";
          defaultCommand = "${fd} --type f";
          fileWidgetCommand = "${fd} --type f";
          tmux.enableShellIntegration = true;
        };

        lsd = {
          enable = true;
        };

        ripgrep = {
          enable = true;
          package = ripgrepWithPCRE2;
          arguments = [
            "--hidden"
          ];
        };
      };
    };
  }
