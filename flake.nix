{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system pkgs;
          modules = [ ./configuration.nix ];
        };
      };
    };
}

# flake.nix
# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#
#     hyprland.url = "github:hyprwm/Hyprland";
#     split-monitor-workspaces = {
#       url = "github:Duckonaut/split-monitor-workspaces";
#       inputs.hyprland.follows = "hyprland"; # make sure this line is present for the plugin to work as intended
#     };
#   };
#
#   outputs =
#     { self
#     , nixpkgs
#     , home-manager
#     , split-monitor-workspaces
#     , ...
#     }:
#     let
#       system = "x86_64-linux";
#       pkgs = nixpkgs.legacyPackages.${system};
#     in
#     {
#       nixosConfigurations = {
#         "desktop" = nixpkgs.lib.nixosSystem {
#           system = "x86_64-linux";
#           modules = [
#             ./configuration.nix
#             home-manager.nixosModules.home-manager
#             {
#               home-manager = {
#                 useGlobalPkgs = true;
#                 useUserPackages = true;
#                 users."arzt" = {
#                   home.stateVersion = "22.11";
#                   wayland.windowManager.hyprland = {
#                     plugins = [
#                       split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
#                     ];
#                   };
#                 };
#               };
#             }
#           ];
#         };
#       };
#     };
# }
