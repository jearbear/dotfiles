{
  config,
  pkgs,
  nixpkgs-master,
  neovim-nightly-overlay,
  ...
}: {
  # Installed packages
  environment.systemPackages = with pkgs; [
    linux-firmware

    git
    delta
    helix
    wget
    firefox
    chromium
    kitty
    jujutsu
    fzf
    bat
    fd
    ripgrep
    watchexec
    mpv
    just
    tree
    jq
    wl-clipboard
    dash
    unzip
    yt-dlp
    wireguard-tools
    zathura # pdf viewer
    feh # image viewer
    gh
    sqlite
    litecli

    nnn
    poppler-utils # pdf previews

    btop
    powertop
    linuxPackages.cpupower

    neovim
    # Using nightly until this fix gets released:
    # https://github.com/neovim/neovim/commit/9607e53cea4f352a7c51ffb75b3ef7f3175a3b13
    # neovim-nightly-overlay.packages.${system}.default
    tree-sitter # for installing tree-sitter parsers
    clang # for installing tree-sitter parsers

    kakoune
    kakoune-lsp
    file # filetype detection

    python3

    catppuccin-cursors
    bibata-cursors
    spotify

    # lsps
    fish-lsp
    marksman # markdown
    vscode-json-languageserver
    vscode-css-languageserver
    nil # nix

    # linters
    shellcheck # bash

    # formatters
    stylua
    ruff # python
    alejandra # nix
    shfmt
    kdlfmt
    prettierd # web stuff
    biome # web stuff
    pgformatter
    taplo # toml

    fuzzel
    rofimoji
    (writeShellScriptBin "dmenu" ''exec ${fuzzel}/bin/fuzzel --dmenu "$@"'')
    (writeShellScriptBin "dmenu-wl" ''exec ${fuzzel}/bin/fuzzel --dmenu "$@"'')
    mako
    libnotify # programmatically send notifications
    xwayland-satellite
    waybar
    brightnessctl
    gammastep
    bluetui
    playerctl # media control
    wiremix # mixer
    swayidle
    swaylock

    # for 1password
    gnome-keyring
    seahorse

    libqalculate

    # password manager
    (pass.withExtensions (exts: [exts.pass-otp]))
    paperkey # for physical backups
    qrencode # for exporting keys to qr codes

    pi-coding-agent
    bubblewrap

    keyd # for application-specific mappings
  ];

  # Fixes the issue causing keyd socket to not be created with the appropriate group.
  # https://github.com/NixOS/nixpkgs/issues/290161
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
    "CAP_SETGID"
  ];
  users.groups.keyd = {};

  programs = {
    niri.enable = true;
    fish.enable = true;

    firefox = {
      enable = true;
      policies = {
        AIControls = {
          Default = {
            Value = "blocked";
            Locked = true;
          };
        };
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          Stories = false;
          SponsoredPocket = false;
          SponsoredStories = false;
          Snippets = false;
          Locked = false;
        };
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        Homepage = {
          StartPage = "none";
          Locked = true;
        };

        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        Preferences = {
          "ui.key.accelKey" = 91;
          "ui.key.menuAccessKey" = 99999;
        };
        SearchEngines = {Remove = ["Google" "Amazon.com" "Bing" "eBay" "Wikipedia (en)" "Perplexity"];};
        SearchSuggestEnabled = false;
        StartDownloadsInTempDirectory = false;
      };
    };

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

    # auto-typing service for use with pass
    ydotool.enable = true;

    # shared clipboard
    kdeconnect.enable = true;
  };

  # This leads to leads to awful rebuild performance
  documentation.man.generateCaches = false;

  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "application/json" = "vim.desktop";
    "image/jpeg" = "feh.desktop";
    "image/png" = "feh.desktop";
    "image/gif" = "feh.desktop";
    "image/webp" = "feh.desktop";
  };

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

    tailscale = {
      enable = true;
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

    # Auto-mounting of USB devices
    udisks2.enable = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;

  hardware.bluetooth.enable = true;

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
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
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
        internal = {
          ids = ["0001:0001:09b4e68d"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              leftmeta = "leftalt";
              leftalt = "leftmeta";
            };
          };
        };
        iris = {
          ids = ["cb10:8256:d72b9d3b"];
          settings = {
            main = {
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

  # Niri has its own portals setup already for screen recording. This is
  # setup to allow using a terminal application as the file picker.
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
    ];

    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
    };
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
      "ydotool" # required to be able to use ydotool
      "keyd" # required for application-specific mappings
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
  };

  security.polkit.enable = true;
}
