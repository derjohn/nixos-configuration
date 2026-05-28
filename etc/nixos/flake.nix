{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/staging-26.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/01fbdeef22b7";
    # https://releases.nixos.org/nixpkgs/nixpkgs-26.05pre985930.01fbdeef22b7

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # gpdFanFlake.url = "github:Cryolitia/gpd-fan-driver";

    };

  outputs = { self, nixpkgs, llm-agents, home-manager, nixos-hardware, ... }: {
    nixosConfigurations = {
      buckle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit llm-agents; };

        modules = [
          ./common-configuration.nix
          ./ollama.nix
          ./specific/buckle/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-9310

          home-manager.nixosModules.home-manager
        ];
      };

      pickpocket = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit llm-agents; };

        modules = [
          ./common-configuration.nix
          ./ollama.nix
          ./specific/pickpocket/configuration.nix

          home-manager.nixosModules.home-manager
          # gpdFanFlake.nixosModules.default # mainline kernel sinc 6.18
        ];
      };
    };
  };
}

