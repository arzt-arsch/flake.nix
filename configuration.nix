{ config, pkgs, appimageTools, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.memtest86.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Use specific kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking = {
    hostName = "arzt-desktop";
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # i18n
  i18n.defaultLocale = "en_US.UTF-8";

  # enable SDDM login manager
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  # enable the plasma desktop
  services.xserver.desktopManager.cinnamon.enable = true;
  # enable the Hyprland window manager
  programs.hyprland.enable = true;

  xdg = {
    mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  environment.sessionVariables = rec {
    # EDITOR = "emacs";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # zsh config
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arzt = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanage" ];
    hashedPassword =
    "$y$j9T$R6dumX8bmYixU0kDIoGka.$7AAL3WUZAamtG9yBLZRqPYzjUYU4igTeLNoxsivj114";
  };

  environment.systemPackages = with pkgs; [
    firefox
    wezterm
    neovim
    waybar
    xdg-desktop-portal-hyprland
    curl
    wget
    code-minimap
    fzf
    rustup
    gcc
    git
    keepassxc
    gnupg
    pinentry
    btop
    gotop
    telegram-desktop
    kickoff
    prismlauncher
    neofetch
    pfetch
    mpv
    nsxiv
    swww
    file
    lm_sensors
    ripgrep
    bat
    virt-manager
    zathura
    unzip
    unrar
    ncmpcpp
    rust-analyzer
    mangohud
    openjdk17
    openjdk8
    wl-clipboard
    jq
    slurp
    grim
    libnotify
    hyprpicker
    bacon
    qbittorrent
    rnix-lsp
    lua-language-server
    rust-analyzer
    starship
    vscode-fhs
    steam
    inotify-tools
    s-tui
    lazygit
    joshuto
    zoxide
  ];

  services.flatpak.enable = true;

  programs.zsh.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    ubuntu_font_family
    nerdfonts
  ];

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        # for wlr support
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  services.syncthing = {
    enable = true;
    user = "arzt"; # Folder for Syncthing's settings and keys
    configDir = "/home/arzt/.config/syncthing/";
    devices = {
      "syncthing-server" = {
        id = "G73YKIP-5LR3WX6-3MB3SEA-OFZ3Z63-GKXDHIF-VXOQYOA-A7EKLJ3-W72FMAT";
      };
    };
    folders = {
      "music" = {
        path = "/home/arzt/Music/";
        devices = [ "syncthing-server" ];
        id = "zxgmd-6avto";
      };
      "keepass" = {
        path = "/home/arzt/.local/keepassdb/";
        devices = [ "syncthing-server" ];
        id = "s4wz9-6tctj";
      };
      "minecraft-client" = {
        path = "/home/arzt/.local/share/PrismLauncher/";
        devices = [ "syncthing-server" ];
        id = "bkurt-rntt4";
      };
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-then 7d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
