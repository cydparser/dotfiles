pkgs : {

  cabal.libraryProfiling = false;

  packageOverrides = pkgs : with pkgs; rec {

    # cmake = lib.overrideDerivation pkgs.cmake (self : {
    #   preConfigure = "export MACOSX_DEPLOYMENT_TARGET='';" + self.preConfigure;
    # });

    darwin-tools = buildEnv {
      name = "darwin-tools";
      paths = [
        bash
        bashCompletion
        bzip2
        cacert
        coreutils
        dos2unix
        gnupg
        gnused
        gnutar
        gzip
        tmux
        xz
        # zsh # autocompletion wreaks havok
      ];
    };

    dev-tools = buildEnv {
      name = "dev-tools";
      paths = [
        diffutils
        gitFull
        gitAndTools.tig
        gnumake
      ];
    };

    emacs-tools = buildEnv {
      name = "emacs-tools";
      paths = with emacs24Packages; [
        colorTheme
        colorThemeSolarized
        emacs
        haskellMode
        idris
        magit
        # structuredHaskellMode
      ];
    };

    java-tools = buildEnv {
      name = "java-tools";
      paths = with nodePackages; [
        jdk
        maven
      ];
    };

    android-tools = buildEnv {
      name = "android-tools";
      paths = [
        androidndk
        androidsdk_4_4
        java-tools
      ];
    };

    # https://github.com/NixOS/nixpkgs/issues/2689
    # nix-env --option use-binary-caches false -iA nixpkgs.hs-tools
    hs-tools = pkgs.haskellPackages.ghcWithPackages (hs : [
      hs.cabal2nix
      hs.cabalInstall
      hs.ghcMod
      hs.happy
      hs.hasktags
      hs.hasktags
      hs.hlint
      hs.hlint
      hs.hoogle
      hs.shake
      hs.stylishHaskell
    ]);

    # remove
    hsEnv = hs-tools;

    net-tools = buildEnv {
      name = "net-tools";
      paths = [
        curl
        netcat
        tcpdump
        tcpflow
        wget
      ];
    };

    nix-tools = buildEnv {
      name = "nix-tools";
      paths = [
        nixops
        nix-prefetch-scripts
        nix-repl
        # https://github.com/madjar/nox
        nox
      ];
    };

    cloud-tools = buildEnv {
      name = "cloud-tools";
      paths = with nodePackages; [
        awscli
        docker
        jq
        nodejs
        packer
      ];
    };

    ruby-tools = buildEnv {
      name = "ruby-tools";
      paths = with rubyLibs; [
        bundler
        pry
        ruby_2_1
      ];
    };

    all-tools = pkgs.buildEnv {
      name = "all-tools";
      paths = [
        dev-tools
        emacs-tools
        net-tools
        nix-tools
      ];
    };

  };

}
