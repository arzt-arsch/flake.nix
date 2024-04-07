{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, nixpkgs-unstable, nix-ld, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
      lib = nixpkgs.lib;
      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      # Overlays-module makes "pkgs.unstable" available in configuration.nix
      overlayModule = ({ config, pkgs, ... }: {
        nixpkgs.overlays = [ overlay ];
      });
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            nix-ld.nixosModules.nix-ld
            overlayModule
            ./configuration.nix
          ];
        };
      };
    };
}
