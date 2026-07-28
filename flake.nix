{
  description = "nixos system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    debounce-mouse.url = "git+ssh://git@github.com/beForged/debounce-mouse.git";
    debounce-mouse.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    debounce-mouse,
    disko,
  }: {
    nixosConfigurations.scarlet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit home-manager;
      };

      modules = [
        ./configuration.nix
        debounce-mouse.nixosModules.default

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
        disko.nixosModules.disko
        ./gateway/disko.nix
        ./gateway/configuration.nix
      ];
    };
  };
}
