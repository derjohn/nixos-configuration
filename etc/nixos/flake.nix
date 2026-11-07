{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/staging-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/01fbdeef22b7";
    # https://releases.nixos.org/nixpkgs/nixpkgs-26.05pre985930.01fbdeef22b7

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    hex = {
      url = "github:anomalyco/hex";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # gpdFanFlake.url = "github:Cryolitia/gpd-fan-driver";

    };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, llm-agents, hex, ... }@inputs: {
    nixosConfigurations = {
      buckle = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs llm-agents; };

        modules = [
          ./common-configuration.nix
          ./ollama.nix
          ./specific/buckle/configuration.nix
          hex.nixosModules.hex
          { programs.hex.enable = true; }
          nixos-hardware.nixosModules.dell-xps-13-9310

          home-manager.nixosModules.home-manager
        ];
      };

      pickpocket = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs llm-agents; };

        modules = [
          ./common-configuration.nix
          ./ollama.nix
          ./specific/pickpocket/configuration.nix
          hex.nixosModules.hex
          { programs.hex.enable = true; }

          home-manager.nixosModules.home-manager
          # gpdFanFlake.nixosModules.default # mainline kernel sinc 6.18
        ];
      };
    };
  };
}

