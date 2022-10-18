# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  # list packages installed in system profile tracking unstable branch
let
	unstable = import <nixos-unstable> { config.allowUnfree = true; };
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in 
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  #allow dirty unfree software (like steam)
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # select latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp24s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # user configuration - set password with passwd
  users.extraUsers.scarlet = {
	isNormalUser = true;
	home = "/home/scarlet";
	extraGroups = [ 
		"wheel"
		"audio"
	];
  };

  home-manager.users.scarlet = {
    imports = [./home-manager/home.nix ];
  };
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # user packages
  users.users.scarlet.packages = with pkgs; [ 
	kitty
	ranger

	streamlink
	unstable.discord
	keepassxc

	neofetch
	gotop

	pinta
	shutter

	spotify
	youtube-dl
	mpv

	ardour
	# sox
	# easyeffects
	helvum

	# pdfslicer
	zathura
  ];

  # default shell specification
  users.users.scarlet = {
	shell = pkgs.zsh;
  };

  # shell
  # programs.zsh.enable = true;


  #steam
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
  	enable = true;
  	autorun = false;
  	exportConfiguration = true;

  	videoDrivers = [ "nvidia" ];
  
  
    #window manager
  	windowManager.i3.package = pkgs.i3-gaps;
  	windowManager.i3.enable = true;
  	displayManager.startx.enable = true;

	libinput = {
		enable = true;
		mouse.accelProfile = "flat";

	};
  };

  #disenable sleep and stuff
  systemd.targets = {
  	sleep.enable = false;
  	suspend.enable = false;
  	hibernate.enable = false;
  	hybrid-sleep.enable = false;
  };

  # compositor - not sure anything other than enable = true does anything
  services.picom = {
	enable = true;
	experimentalBackends = true;
	backend = "glx";
	fade = true;
	settings = {
		blur = { 
			method = "dual_kawase";
    			size = 20;
   			deviation = 5.0;
		};
	};
	inactiveOpacity = 0.8;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # tailscale enable
  services.tailscale.enable = true;

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  # disable pulseaudio for pipewire - want to fix mic sound
  services.pipewire = {
	enable = true;
	alsa = {
		enable = true;
		support32Bit = true;
	};
	pulse.enable = true;
	jack.enable = true;
  };


  # List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
    vim 
	pciutils # contains lspci
    ntfs3g
    fuse
    xdg-utils
    home-manager

	# internet 
    wget
    firefox
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
	racket-minimal
	# tracked in unstable
	unstable.go 
	heroku
	gopls
	jetbrains.idea-community
	jdk11
    python3

	# ardour plugins
	lv2
	x42-plugins
	tunefish
	boops

	# sound configuration
	carla
	cadence
	pavucontrol 
    pulseaudio
  ];

  xdg.mime.defaultApplications = {
	"application/pdf" = "firefox.desktop";
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
  # services.openssh.enable = true;
 
  # Enable the OpenSSH server 
  # services.sshd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
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

