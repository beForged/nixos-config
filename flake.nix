{
  description = "nixos system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # used for packages built from source (cuda), see overlays/pinned.nix.
    # use the `flakeup` alias for routine updates, it skips this input.
    # `flakeup-pinned` bumps this pinned input (long rebuild possible)
    nixpkgs-pinned.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pinned to the nixpkgs rev from before the 2026-11-18 update (hyprland 0.56.2).
    # Hyprland >= 0.57 dropped hyprland.conf support in favor of hyprland.lua and
    # auto-generates a default lua config on first launch, which silently replaced
    # our config. Remove this pin once home-manager/hyprland.nix is migrated to
    # configType = "lua".
    nixpkgs-hyprland.url = "github:nixos/nixpkgs/02c087f3fe673c9e317f206a627cb6b910336dbe";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    debounce-mouse.url = "git+ssh://git@github.com/beForged/debounce-mouse.git";
    debounce-mouse.inputs.nixpkgs.follows = "nixpkgs";

    lastfmanalysis.url = "git+ssh://git@github.com/beForged/lastfmanalysis.git";
    lastfmanalysis.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-pinned,
    nixpkgs-hyprland,
    home-manager,
    debounce-mouse,
    lastfmanalysis,
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.scarlet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit home-manager nixpkgs-hyprland;
      };

      modules = [
        ./configuration.nix
        {nixpkgs.overlays = [(import ./overlays/pinned.nix {inherit nixpkgs-pinned;})];}
        debounce-mouse.nixosModules.default
        lastfmanalysis.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.scarlet = import ./home-manager/home.nix;
        }
      ];
    };

    nixosConfigurations.gateway = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./gateway/configuration.nix
      ];
    };
  };
}
