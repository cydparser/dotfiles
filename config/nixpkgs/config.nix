pkgs : {

  cabal.libraryProfiling = false;

  packageOverrides = pkgs : with pkgs; rec {

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
        gnutls
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
      ];
    };

    java-tools = buildEnv {
      name = "java-tools";
      paths = [
        maven
        openjdk8
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
