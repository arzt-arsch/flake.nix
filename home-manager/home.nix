{ pkgs, hyprland, split-monitor-workspaces, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "arzt";
  home.homeDirectory = "/home/arzt";

  # home.enableNixpkgsReleaseCheck = false;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    source-code-pro
    font-awesome
    ubuntu_font_family
    nerdfonts

    materia-kde-theme
    libsForQt5.qtstyleplugin-kvantum
  ];

  gtk.enable = true;
  gtk.iconTheme.package = pkgs.papirus-icon-theme;
  gtk.iconTheme.name = "Papirus-Dark";

  gtk.theme.package = pkgs.materia-theme;
  gtk.theme.name = "Materia-dark-compact";

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=MateriaDark
  '';

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_USE_PORTAL = 1;
  };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = hyprland.packages.${pkgs.system}.hyprland;
  #   plugins = [
  #     split-monitor-workspaces.packages.${pkgs.system}.default
  #   ];
  #   extraConfig = ''
  #   '';
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/arzt/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  # systemd.user.sessionVariables = {
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
