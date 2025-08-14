# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}:
# list packages installed in system profile tracking unstable branch
let
  # unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  unstable = import <nixos-unstable> {config.allowUnfree = true;};
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     unstable = import unstableTarball {
  #       config = config.nixpkgs.config;
  #     };
  #   };
  # };

  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  #allow dirty unfree software (like steam)
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # select linux kernel
  # use default lts, latest kernel may cause issues w nvidia (add _latest for latest kernel)
  boot.kernelPackages = pkgs.linuxPackages;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp24s0.useDHCP = true;

  networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  services.adguardhome = {
    enable = true;
    openFirewall = false;
    port = 3001;
    settings = {
      #http.address = "127.0.0.1:9001";
      dns.bind_host = "192.168.86.20";
      dns.port = 3005;
      schema_version = 20;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # security.sudo.extraRules = [{
  #   runAs = "root";
  #   groups = ["wheel"];
  #   commands = [{
  #     command = "run/current-system/sw/bin/shutdown";
  #     options = ["NOPASSWD"];
  #   }];
  # }];

  security.sudo.extraConfig = ''
    %wheel  ALL=NOPASSWD: /run/current-system/sw/bin/shutdown
  '';

  # user configuration - set password with passwd
  users.extraUsers.scarlet = {
    isNormalUser = true;
    home = "/home/scarlet";
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ];
  };

  home-manager.users.scarlet = {
    imports = [./home-manager/home.nix];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  #experimental features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # allowed for r2modman (lethal company) 14/12/2023
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # user packages
  users.users.scarlet.packages = with pkgs; [
    kitty
    ranger

    streamlink
    unstable.discord
    unstable.armcord
    keepassxc

    neofetch
    gotop

    pinta
    kdePackages.kolourpaint
    shutter
    foliate

    spotify
    yt-dlp
    mpv

    ardour
    # sox
    helvum
    audacity

    # pdfslicer
    zathura

    sonic-pi

    unstable.osu-lazer-bin
    #steam mods
    r2modman

    obsidian
    anki-bin

    #game
    godot_4
  ];

  # enable jellyfin
  services.jellyfin = {
    enable = true;
    user = "scarlet";
  };

  services.deluge = {
    enable = true;
    web.enable = true;
  };

  # default shell specification
  users.users.scarlet = {
    shell = pkgs.zsh;
  };

  # shell
  programs.zsh.enable = true;

  #steam
  programs.steam.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;

    videoDrivers = ["nvidia"];

    #window manager
    # windowManager.i3.package = pkgs.i3-gaps;
    # windowManager.i3.enable = true;
    displayManager.startx.enable = true;
  };

  hardware.nvidia = {
    powerManagement.enable = true;

    open = true;
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  #disenable sleep and stuff
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # run git server to serve obsidian vault ++
  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";
    settings = {
      server = {
        DOMAIN = "nixos.tail097e5.ts.net";
        ROOT_URL = "http://nixos.tail097e5.ts.net/forgejo";
        HTTP_PORT = 3000;
        SSH_PORT = 2222;
      };
    };
  };

  # create git user for forgejo
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/forgejo";
    shell = pkgs.bash;
  };

  users.groups.git = {};
  # mount tempfile for forgejo
  systemd.tmpfiles.rules = [
    "d /var/lib/forgejo/custom 0755 git git - -"
  ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
        traefik = {
          address = ":8080"; # Enable dashboard endpoint
        };
      };

      api = {
        dashboard = true;
        insecure = true;
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          forgejo = {
            rule = "Host(`nixos.tail097e5.ts.net`) && PathPrefix(`/forgejo`)";
            service = "forgejo";
            entryPoints = ["web"];
            middlewares = ["strip-forgejo-prefix"];
          };
        };
        middlewares = {
          strip-forgejo-prefix = {
            stripPrefix.prefixes = ["/forgejo"];
          };
        };
        services = {
          forgejo = {
            loadBalancer.servers = [
              {
                url = "http://127.0.0.1:3000";
              }
            ];
          };
        };
      };
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # tailscale enable
  services.tailscale.enable = true;

  services.pulseaudio.enable = false;
  # disable pulseaudio for pipewire - want to fix mic sound
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."99-deepfilter-mono-source" = {
      "context.modules" = [
        {
          "name" = "libpipewire-module-filter-chain";
          "args" = {
            "filter.graph" = {
              "nodes" = [
                {
                  "type" = "ladspa";
                  "name" = "DeepFilter Mono";
                  "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                  "label" = "deep_filter_mono";
                  "control" = {
                    "Attenuation Limit (dB)" = 100;
                  };
                }
              ];
            };
            "audio.position" = ["MONO"];
            "audio.rate" = "48000";
            "capture.props" = {
              "node.passive" = true;
            };
            "playback.props" = {
              "media.class" = "Audio/Source";
            };
          };
        }
      ];
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    pciutils # contains lspci
    psmisc # utils
    dig
    busybox
    ntfs3g # ntfs mounting
    fuse
    xdg-utils
    home-manager
    alejandra # linter

    # internet
    wget
    firefox-bin
    google-chrome
    tailscale

    lutris

    # graphics
    glxinfo
    feh

    ############
    #dev tools #
    ############
    gnumake
    gcc
    git
    racket
    # tracked in unstable
    unstable.go
    gopls
    jetbrains.idea-community
    jdk11
    python3
    flyctl
    docker
    sqlite

    # ardour plugins
    lv2
    x42-plugins
    boops

    # sound configuration
    pulseaudio # needed for pactl
    pavucontrol
    ffmpeg

    deepfilternet
    ladspa-sdk

    #jellyfin pkgs
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg

    #kvm
    input-leap

    #font
    noto-fonts-cjk-sans
  ];

  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
  };

  fileSystems."/mnt" = {
    device = "UUID=2618B8A018B87083";
    fsType = "ntfs";
    options = ["defaults"];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22 2222];
    listenAddresses = [
      {
        addr = "127.0.0.1";
        port = 2222;
      }
      {
        addr = "100.111.74.101";
        port = 2222;
      }
    ];
  };

  # Enable the OpenSSH server
  # services.sshd.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    # for input leap
    allowedTCPPorts = [24800];
    interfaces.tailscale0.allowedTCPPorts = [2222];
    # networking.firewall.allowedUDPPorts = [ ... ];
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
