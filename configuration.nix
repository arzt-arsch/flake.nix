{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/e1ee359d16a1886f0771cc433a00827da98d861c.tar.gz";
    })
    {
      config.allowUnfree = true;
    };
in
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

  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.initrd.kernelModules = [ "amdgpu" "v4l2loopback" "kvm-amd" "vfio-pci" ];

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
    hostName = "arzt-desktop";
    networkmanager.enable = true;
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
  # enable the cinnamon desktop
  services.xserver.desktopManager.cinnamon.enable = true;
  # enable the Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.steam.enable = true;
  programs.thunar.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  xdg = {
    mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
  xdg.portal.enable = true;

  environment.sessionVariables = {
    # EDITOR = "emacs";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # zsh config
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      mesa.drivers
    ];
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arzt = {
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
    soundux
    scrcpy
    picard
    cli-visualizer
    bottom
    vscodium-fhs
    freshfetch
    home-manager
    nb
    xorg.xrdb
    eww-wayland
    unstable.mpvpaper
  ];

  services.flatpak.enable = true;

  programs.zsh.enable = true;

  # Enable libvirtd daemon
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
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
