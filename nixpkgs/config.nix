pkgs : {

  cabal.libraryProfiling = false;

  packageOverrides = pkgs : with pkgs; rec {

    # cmake = lib.overrideDerivation pkgs.cmake (self : {
    #   impureEnvVars = [ "CMAKE_OSX_DEPLOYMENT_TARGET" ];
    # });

    systemEnv = buildEnv {
      name = "system-env";
      paths = [
        bash
        bashCompletion
        bzip2
        cacert
        dos2unix
        gnupg
        gnused
        gnutar
        gzip
        tmux
        xz
        # autocompletion wreaks havok
        # zsh
      ];
    };

    androidEnv = buildEnv {
      name = "android-env";
      paths = [
        androidndk
        androidsdk_4_4
      ];
    };

    devEnv = buildEnv {
      name = "system-env";
      paths = [
        # emacs24Macport
        # darcs
        diffutils
        # gcc
        git
        gitAndTools.tig
        gnumake
        mercurial
      ];
    };

    # https://github.com/NixOS/nixpkgs/issues/2689
    # nix-env --option use-binary-caches false -iA nixpkgs.hsEnv
    hsEnv = pkgs.haskellPackages.ghcWithPackages (hs : [
      hs.cabalInstall
      hs.cabal2nix
      hs.ghcMod
      hs.hasktags
      hs.hlint
      hs.hoogle
      hs.shake
    ]);

    javaEnv = buildEnv {
      name = "java-env";
      paths = with nodePackages; [
        maven
      ];
    };

    netEnv = buildEnv {
      name = "net-env";
      paths = [
        netcat
        # openssh
        wget
      ];
    };

    nixTools = buildEnv {
      name = "nix-tools";
      paths = [
        nix
        nix-repl
        nixops
      ];
    };

    webEnv = buildEnv {
      name = "web-env";
      paths = with nodePackages; [
        awscli
        jq
        nodejs
        packer
      ];
    };

    rubyEnv = buildEnv {
      name = "ruby-env";
      paths = with rubyLibs; [
        bundler
        pry
        ruby_2_1
      ];
    };

    all-tools = pkgs.buildEnv {
      name = "all-tools";
      paths = [
        devEnv
        javaEnv
        netEnv
        systemEnv
        webEnv
      ];
    };

  };

}
