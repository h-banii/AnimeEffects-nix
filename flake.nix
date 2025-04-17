{
  description = "2D Animation Tool";

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = self.packages.${system}.animeeffects;
          animeeffects = pkgs.callPackage ./packages/animeeffects { };
        }
      );
    };
}
