{

  allowUnfree = true;

  packageOverrides = super: let self = super.pkgs; in {
    haskellPackages = super.haskellPackages.override {
      overrides = self: super: {
        intero-nix-shim = self.callPackage ~/src/intero-nix-shim {};
      };
    };
  };

}
