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
      url = "github:mangowm/mango/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, mango, noctalia, noctalia-greeter, chaotic, nix-gaming, nvf, ... }@inputs:
    let
      system = "x86_64-linux";
      vars = import ./vars.nix;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.${vars.hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs vars; };
        modules = [
          ./host/boot.nix
          ./host/services.nix
          ./host/packages.nix
          ./host/hardware-configuration.nix
          ./modules/core/base.nix
          ./modules/core/latency.nix
          ./modules/core/audio.nix
          ./modules/core/gpu.nix
           ./modules/core/docker.nix
          ./modules/core/cpu.nix
          ./modules/core/ananicy.nix
          chaotic.nixosModules.default
          nix-gaming.nixosModules.pipewireLowLatency
          nix-gaming.nixosModules.platformOptimizations
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
