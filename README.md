# AnimeEffects-nix

## Quick usage

```shell
nix run github:h-banii/AnimeEffects-nix
```

## Configuration example

```nix
{
  inputs.animeeffects = {
    url = "github:h-banii/AnimeEffects-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
```

```nix
{
  pkgs,
  inputs,
  ...
}:
let
  animeEffectsPkgs = inputs.animeeffects.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = [
    animeEffectsPkgs.animeeffects
  ];
}
```
