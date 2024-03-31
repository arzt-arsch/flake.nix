{ config, pkgs, ... }:

let
  username = "arzt";
  lib = pkgs.lib;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB boot loader.
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    enable = true;
    memtest86.enable = true;
    useOSProber = true;
    splashImage = ./grub-background.jpg;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.initrd.kernelModules = [ "amdgpu" "v4l2loopback" "kvm-amd" "vfio-pci" ];
  boot.kernel.sysctl = { "vm.swappiness" = 0; };

  # Use specific kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  # Networking
  networking = {
    hostName = "${username}-desktop";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # i18n
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "ru_RU.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  # enable SDDM login manager
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "hyprland";
    autoLogin.enable = true;
    autoLogin.user = username;
  };
  # enable the desktop
  # services.xserver.desktopManager.hyprland.enable = true;
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    wlr = {
      enable = true;
    };
  };

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.thunar.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  xdg = {
    mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

  # For hardware acceleration
  # nixpkgs.config.packageOverrides = pkgs: {
  #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  # };

  # Enable OpenGL
  hardware.opengl = {
    # Mesa
    enable = true;

    # Vulkan
    driSupport = true;
    driSupport32Bit = true; # Steam support

    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.jack = {
    jackd.enable = true;
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device
    # (supports programs like Steam)
    loopback = {
      enable = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
  };

  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanage" "jackaudio" "docker" "kvm" ];
    hashedPassword =
      "$y$j9T$R6dumX8bmYixU0kDIoGka.$7AAL3WUZAamtG9yBLZRqPYzjUYU4igTeLNoxsivj114";
  };

  environment.systemPackages = with pkgs; [
    firefox
    wezterm
    alacritty
    neovim
    (waybar.overrideAttrs
      (oldAttrs: {
        # for wlr support
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true " ];
      })
    )
    chezmoi
    dunst
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
    rofi-wayland
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
    spice
    win-spice
    virt-manager
    virt-viewer
    zathura
    unzip
    unrar
    ncmpcpp
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
    starship
    inotify-tools
    s-tui
    lazygit
    zoxide
    qpwgraph
    obs-studio
    pulsemixer
    swappy
    mypaint
    musikcube
    direnv
    cmatrix
    blender
    scrcpy
    picard
    cli-visualizer
    bottom
    vscodium-fhs
    freshfetch
    home-manager
    nb
    xorg.xrdb
    mpvpaper
    vulkan-tools
    vulkan-validation-layers
    valgrind
    steam-run
    obsidian
    joshuto
    figlet
    lolcat
    loc
    dwl
    discord
    vesktop
    distrobox
  ];

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraLibraries ? pkgs': [ ], ... }: {
        extraLibraries = pkgs': (extraLibraries pkgs') ++ ([
          pkgs'.gperftools
        ]);
      });
    })
  ];

  services.flatpak.enable = true;

  programs.zsh.enable = true;

  # Enable libvirtd daemon
  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
  };

  # enable access from hooks to bash, modprobe, systemctl, etc
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
          ];
        };
      in
      [ env ];
  };

  services.spice-vdagentd.enable = true;
  services.udev.extraRules = ''
    # Access to /dev/bus/usb/* devices. Needed for virt-manager USB
    # redirection.
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0664", GROUP="wheel"
  '';
  programs.dconf.enable = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-then 7d";
    };
  };

  programs.nix-ld.enable = true;
  environment.variables = lib.mkForce {
    NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
      stdenv.cc.cc
      openssl
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva
      pipewire
      xorg.libxcb
      xorg.libXdamage
      xorg.libxshmfence
      xorg.libXxf86vm
      libelf

      # Required
      glib
      gtk2
      bzip2

      # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE
      gnome2.GConf
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      # Only libraries are needed from those two
      libudev0-shim

      # Verified games requirements
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libidn
      tbb

      # Other things from runtime
      flac
      freeglut
      libjpeg
      libpng
      libpng12
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
      libdbusmenu-gtk2
      libindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      gnome2.pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsaLib
      expat
      # Needed for electron
      libdrm
      mesa
      libxkbcommon

      wlroots
      xwayland
      wayland
      wayland.dev
      libinput
      libinput.dev
      xorg.xcbutilwm
      xorg.xcbutilwm.dev
    ];
    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

    # EDITOR = "emacs";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # zsh config
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
