{
  config,
  pkgs,
  ...
}: {
  # Installed packages
  environment.systemPackages = with pkgs; [
    linux-firmware
    networkmanagerapplet

    docker
    git
    delta
    neovim
    helix
    wget
    firefox
    chromium
    kitty
    jujutsu
    fzf
    direnv
    bat
    fd
    ripgrep
    yazi # file manager
    mpv
    stow
    just
    tree
    jq
    foot
    wl-clipboard
    pass

    kakoune
    kakoune-lsp
    file # filetype detection

    beam27Packages.elixir_1_17
    beam27Packages.elixir-ls

    fish-lsp

    python3
    ruff

    aichat

    catppuccin-cursors
    bibata-cursors
    spotify

    # gcc11 # for nvim treesitter parser installs
    # lsps and formatters
    marksman
    alejandra
    nodePackages.vscode-json-languageserver
    shellcheck

    powertop
    btop

    mako
    xwayland-satellite
    waybar
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
    polkit_gnome
    brightnessctl
    tofi
    gammastep
    bluetui

    seahorse

    libqalculate
    grim
    swayidle
    swaylock

    alacritty
  ];

  programs = {
    niri.enable = true;
    fish.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["jerry"];
    };

    gnupg.agent = {
      enable = true;
      # pinentry.Package = pkgs.pinentry-curses;
    };
  };

  # Services
  services = {
    syncthing = {
      enable = true;
      user = "jerry";
      dataDir = "/home/jerry";
    };

    # Auto-derive location for gammastep
    geoclue2.enable = true;

    calibre-web = {
      enable = true;
      user = "jerry";
      listen = {
        ip = "0.0.0.0";
        port = 8110;
      };
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable hibernation
  boot.kernelParams = ["resume=/" "resume_offset=436224"];
  boot.resumeDevice = "/dev/nvme0n1p2";

  hardware.bluetooth.enable = true;

  # Setup auto-suspend and CPU frequency scaling
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.auto-cpufreq.enable = true;

  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.type = "simple";
  };
  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  # Sleep settings
  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=24h
    SuspendEstimateSec=3h
  '';

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    firewall = {
      allowedUDPPorts = [
        5353 # for Spotify device discovery
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard config
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              leftmeta = "leftalt";
              leftalt = "leftmeta";
            };
          };
        };
      };
    };
  };
  console.useXkbConfig = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jerry = {
    isNormalUser = true;
    description = "Jerry";
    extraGroups = ["networkmanager" "wheel" "video"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  security.rtkit.enable = true; # improved perf for pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      inter
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.subpixel.rgba = "none";
    fontconfig.subpixel.lcdfilter = "default";
    fontconfig.hinting.style = "full";
  };

  security.polkit.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
