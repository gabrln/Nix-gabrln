{
  description = "Gabriel's NixOS config with MangoWM and Noctalia";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Opt-in state persistence inputs
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, mango, noctalia, noctalia-greeter, antigravity-nix, nixvim, impermanence, ... }@inputs:
    let
      system = "x86_64-linux";
      vars = import ./vars.nix;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.${vars.hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs vars; };
        modules = [
          ./hosts/default/default.nix
          ./modules/nixos/base.nix
          ./modules/nixos/latency.nix
          ./modules/nixos/audio.nix
          ./modules/nixos/gpu.nix
          ./modules/nixos/docker.nix
          mango.nixosModules.mango
          noctalia-greeter.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs vars; };
            home-manager.users.${vars.userName} = import ./modules/home/home.nix;
          }
        ];
      };
    };
}
