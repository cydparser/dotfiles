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

  dir = ../..;

  ripgrepWithPCRE2 = pkgs.ripgrep.override {withPCRE2 = true;};

  shellAliases = {
    k2pdf = "k2pdfopt -ui- -dev k2 -o %s-k2";

    l = "eza -la --sort newest";
    lt = "eza --tree --icons";
    lt2 = "eza --tree --icons --level 2";
    lt3 = "eza --tree --icons --level 3";
  };
in
  with lib; {
    options = {
      dotfiles = {
        dev = {
          haskell = bool true;
          nix = bool true;
          reStructuredText = bool true;
          toml = bool true;
          yaml = bool true;
        };

        fonts = bool true;
        gui = bool true;
        lexical = bool true;
        systemd = bool true;
        wayland = bool false;

        username = lib.mkOption {
          type = lib.types.str;
          default = "cyd";
        };
      };
    };

    config = {
      home.username = cfg.username;
      home.homeDirectory = "/home/${cfg.username}";

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
          libtree
          lld
          nix-prefetch-git
          nix-output-monitor
          nurl
          procs
          shellcheck
          shfmt
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
          (
            haskell.packages.ghc98.ghcWithPackages (ps:
              with ps;
                lib.lists.map (p: haskell.lib.dontCheck (haskell.lib.doJailbreak p)) [
                  pretty-simple
                  zlib
                ])
          )
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
          nixfmt-rfc-style
          patchelf
          statix
        ]
        ++ optionals cfg.dev.reStructuredText [
          python3
          sphinx
        ]
        ++ optionals (cfg.dev.toml || cfg.dev.rust) [
          taplo-lsp
        ]
        ++ optionals cfg.dev.yaml [
          yamlfmt
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
          calibre
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
          "config/fourmolu.yaml"
          "config/gnupg/gpg-agent.conf"
          "config/gtk-3.0/settings.ini"
          "config/ispell/words"
          "config/nix/nix.conf"
          "config/psql/psqlrc"
          "config/readline/inputrc"
          "config/shellcheckrc"
          "config/stylish-haskell/config.yaml"
          "config/termite/config"
          "config/tmux/conf"
          "config/xmobar/xmobarrc"
          "config/yamlfmt/.yamlfmt"
          "config/zsh/.zshrc"
          "gemrc"
          "ghci"
          "gtkrc-2.0"
          "haskeline"
          "hlint.yaml"
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

        emacs = {
          enable = true;

          package =
            if cfg.wayland
            then pkgs.emacs29-pgtk
            else pkgs.emacs29;

          extraPackages = epkgs: [
            epkgs.pdf-tools
            (epkgs.treesit-grammars.with-grammars (ps:
                builtins.attrValues (lib.attrsets.filterAttrs (k: _: k != "tree-sitter-typst") ps)))
            epkgs.vterm
          ];
        };

        eza = {
          enable = true;
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

        jujutsu = {
          enable = true;

          settings = {
            user = {
              # XXX
              name = "cydparser";
              email = "cydparser@gmail.com";
            };
          };
        };

        lsd = {
          enable = true;
        };

        nushell = {
          enable = true;
          shellAliases =
            shellAliases
            // {
              "l" = "ls -a";
            };
        };

        ripgrep = {
          enable = true;
          package = ripgrepWithPCRE2;
        };

        zsh = {
          enable = true;
          inherit shellAliases;
        };
      };

      nixpkgs = {
        config.allowUnfree = true;
        config.allowUnfreePredicate = p: true;
      };
    };
  }
