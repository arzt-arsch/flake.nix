{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, nix-ld, ... }:
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
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system pkgs lib;
          modules = [
            nix-ld.nixosModules.nix-ld
            ./configuration.nix
          ];
        };
      };
    };
}
