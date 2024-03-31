{
  description = "Home Manager configuration of arzt";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };

    ags.url = "github:Aylur/ags";
  };

  outputs = { nixpkgs, home-manager, split-monitor-workspaces, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nix-colors = nix-colors;
    in
    {
      homeConfigurations."arzt" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit nix-colors split-monitor-workspaces hyprland inputs;
        };

        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
      };
    };
}
