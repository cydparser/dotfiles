self: super:
let
  inherit (super) lib fetchurl makeWrapper stdenv;
  inherit (self) bash jre;
in {
  eclipse = with self.eclipses; eclipseWithPlugins {
    eclipse = eclipse-sdk;
    jvmArgs = [
      "-Xmx2G"
      ("-Dchrome.location=" + (toString ~/.nix-profile/bin/google-chrome-stable))
    ];
    plugins = [
      plugins.bytecode-outline
      plugins.color-theme
      plugins.spotbugs
    ];
  };

  osmosis = stdenv.mkDerivation rec {
    name = "osmosis-overlay";
    version = "0.46";

    buildInputs = [ bash jre makeWrapper ];

    sourceRoot = ".";

    src = fetchurl {
      name = "osmosis-${version}.tgz";
      url = "https://bretth.dev.openstreetmap.org/osmosis-build/osmosis-${version}.tgz";
      sha256 = "1yviisf4dqx3ppsgyvph64ylnkvs34lj7gv27ry8pr7y397bvdwa";
    };

    installPhase = ''
      mkdir -p $out/bin
      mv bin/osmosis $out/bin/
      for d in config lib; do mv $d $out/$d; done

      wrapProgram $out/bin/osmosis \
        --prefix PATH : ${bash}/bin \
        --set JAVACMD ${jre}/bin/java \
        --set JAVA_HOME ${jre}
    '';
  };
}
