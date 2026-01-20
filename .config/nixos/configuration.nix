{
  config,
  pkgs,
  ...
}: {
  # Installed packages
  environment.systemPackages = with pkgs; [
    linux-firmware
    networkmanagerapplet

    git
    delta
    neovim
    helix
    wget
    firefox
    librewolf
    chromium
    kitty
    jujutsu
    fzf
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
    dash
    nnn
    yt-dlp
    wireguard-tools

    kakoune
    kakoune-lsp
    file # filetype detection

    python3

    aichat

    catppuccin-cursors
    bibata-cursors
    spotify

    # gcc11 # for nvim treesitter parser installs
    # lsps and formatters
    # lsps
    fish-lsp
    marksman # markdown
    nodePackages.vscode-json-languageserver
    shellcheck # bash
    nil # nix

    # linters

    # formatters
    stylua
    ruff
    alejandra # nix

    powertop
    btop

    fuzzel
    rofimoji
    mako
    xwayland-satellite
    waybar
    brightnessctl
    tofi
    gammastep
    bluetui

    keepassxc

    # for 1password
    gnome-keyring
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

    # also takes care of installing nix-direnv
    direnv.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["jerry"];
    };

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    ssh = {
      startAgent = true;
    };
  };

  # This leads to leads to awful rebuild performance
  documentation.man.generateCaches = false;

  # Services
  services = {
    connman = {
      enable = false;
    };

    syncthing = {
      enable = true;
      user = "jerry";
      dataDir = "/home/jerry";
    };

    # Auto-derive location for gammastep
    geoclue2.enable = true;

    # Why are these enabled by default???
    gnome.gcr-ssh-agent.enable = false;
    # This gets 1password to work
    gnome.gnome-keyring.enable = true;

    postgresql = {
      enable = true;
      settings = {
        port = 9876;
      };
      # Allow passwordless access for all users
      authentication = ''
        local all all trust
      '';
      ensureUsers = [
        {
          name = "postgres";
          ensureClauses = {
            createdb = true;
          };
        }
      ];
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable hibernation
  # boot.kernelParams = [
  #   "resume=/"
  #   "resume_offset=436224"
  # ];
  # boot.resumeDevice = "/dev/nvme0n1p2";

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
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
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

  virtualisation.docker = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jerry = {
    isNormalUser = true;
    description = "Jerry";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker" # to run docker commands without sudo
    ];
    packages = [];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
      noto-fonts-color-emoji
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
