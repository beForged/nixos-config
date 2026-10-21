{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./plex-gateway.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  time.timeZone = "America/New_York";

  networking.useDHCP = true;

  boot.loader.grub.configurationLimit = 10;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.trusted-users = ["root" "scarlet"];

  users.users.scarlet = {
    isNormalUser = true;
    home = "/home/scarlet";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsvUGQ/UAYG9RkeGzN1t7c3EHzuIy3so85fe+iQDB8Z oci"
    ];
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    # defaults to true, which opens 22 on every interface (incl. public).
    # ssh is only allowed over tailscale, see firewall below.
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    # Plex public access
    allowedTCPPorts = [32400];
    # Tailscale-only ports (SSH)
    interfaces.tailscale0.allowedTCPPorts = [22];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    tailscale
    htop
    kitty.terminfo
    tcpdump
  ];

  system.stateVersion = "24.05";
}
