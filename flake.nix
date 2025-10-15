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
          animeeffects = pkgs.qt6Packages.callPackage ./pkgs/animeeffects { };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            name = "animeeffects-shell";

            packages = with pkgs; [
              qt6.full
              cmake
              clang
              ninja
            ];

            CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
            CMAKE_COLOR_DIAGNOSTICS = "ON";

            shellHook = ''
              setup() {
                cmake -S . -B build -G "Ninja Multi-Config"
              }
              build() {
                cmake --build build --config Debug -j $NIX_BUILD_CORES
              }
            '';
          };
        }
      );
    };
}
