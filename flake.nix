{
  description = "nixos system configuration";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
   outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.scarlet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
     homeConfigurations.scarlet = home-manager.users.user {
      home.file = "/home/scarlet";
      # Add the path to your Home Manager configuration file here
      homeManagerConfigurations = { my-home-manager = ./home-manager/home.nix; };
    };
  };
}

