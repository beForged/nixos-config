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

  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };


  networking.firewall = {
    enable = true;
    # Plex public access
    allowedTCPPorts = [80 443 32400];
    # Tailscale-only ports (traefik dashboard, SSH)
    interfaces.tailscale0.allowedTCPPorts = [8080 22];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    tailscale
    htop
  ];

  system.stateVersion = "24.05";
}
