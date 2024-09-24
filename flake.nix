{
  description = "Home Manager configuration of omp";

  inputs = {
    # Source of Nixpkgs and Home Manager.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # Define Home Manager configuration
      homeConfigurations.omp = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Reference the home.nix module
        modules = [ ./home.nix ];
      };
    };
}

