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
  services.xserver.desktopManager.plasma5.enable = true;
  # enable the Hyprland window manager
  programs.hyprland.enable = true;

  xdg = {
    mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  # Enable sound.
  sound.enable = true;
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
  };

  environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # zsh config
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  environment.systemPackages = with pkgs; [
    (pkgs.buildFHSUserEnv {
      name = "fhs";
      targetPkgs = pkgs: with pkgs; [
        desktop-file-utils
        xorg.libXcomposite
        xorg.libXtst
        xorg.libXrandr
        xorg.libXext
        xorg.libX11
        xorg.libXfixes
        libGL
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-plugins-base
        libdrm
        xorg.xkeyboardconfig
        xorg.libpciaccess
        glib
        gtk2
        bzip2
        zlib
        gdk-pixbuf
        xorg.libXinerama
        xorg.libXdamage
        xorg.libXcursor
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXxf86vm
        xorg.libXi
        xorg.libSM
        xorg.libICE
        curlWithGnuTls
        nspr
        nss
        cairo
        pango
        expat
        dbus
        cups
        libcap
        SDL2
        libusb1
        udev
        dbus-glib
        atk
        at-spi2-atk
        libudev0-shim
        xorg.libXt
        xorg.libXmu
        xorg.libxcb
        xorg.xcbutil
        xorg.xcbutilwm
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        libGLU
        libuuid
        libogg
        libvorbis
        SDL
        SDL2_image
        glew110
        openssl
        libidn
        tbb
        wayland
        mesa
        libxkbcommon
        vulkan-loader
        flac
        freeglut
        libjpeg
        libpng12
        libpulseaudio
        libsamplerate
        libmikmod
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        xorg.libXft
        libvdpau
        alsa-lib
        harfbuzz
        e2fsprogs
        libgpg-error
        keyutils.lib
        libjack2
        fribidi
        p11-kit
        gmp
        libtool.lib
        xorg.libxshmfence
        at-spi2-core
        gnumake
        gcc
      ];
      multiPkgs = pkgs: (with pkgs;
        [
          fontconfig
          cmake
          freetype
          pkg-config
        ]);
      profile = ''export FHS=1'';
      runScript = "zsh";
    })
    firefox
    wezterm
    neovim
    curl
    wget
    code-minimap
    fzf
    rustup
    gcc
    git
    keepassxc
    syncthing
    gnupg
    pinentry
    btop
    gotop
    telegram-desktop
    waybar
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
  ];
  services.flatpak.enable = true;

  programs.zsh.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
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
    configDir = "/home/arzt/Documents/.config/syncthing";
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
      "projects" = {
        path = "/home/arzt/projects/";
        devices = [ "syncthing-server" ];
        id = "s9e7r-nlkhe";
      };
      "config" = {
        path = "/home/arzt/.config/";
        devices = [ "syncthing-server" ];
        id = "tvbon-humhs";
      };
      "keepass" = {
        path = "/home/arzt/.local/keepassdb/";
        devices = [ "syncthing-server" ];
        id = "s4wz9-6tctj";
      };
    };
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-then 14d";
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
