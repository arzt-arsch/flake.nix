{ pkgs, hyprland, split-monitor-workspaces, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "arzt";
  home.homeDirectory = "/home/arzt";

  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "22.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    source-code-pro
    font-awesome
    ubuntu_font_family
    nerdfonts

    materia-kde-theme
    libsForQt5.qtstyleplugin-kvantum
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.default
    ];
    extraConfig = ''
      source = $XDG_CONFIG_HOME/hypr/main.conf
    '';
  };

  home.file = { };

  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
