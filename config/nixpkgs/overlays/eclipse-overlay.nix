self: super: {
  eclipse = with self.eclipses; eclipseWithPlugins {
    eclipse = eclipse-sdk;
    jvmArgs = [ ("-Dchrome.location=" + (toString ~/.nix-profile/bin/google-chrome-stable)) ];
  };
}
