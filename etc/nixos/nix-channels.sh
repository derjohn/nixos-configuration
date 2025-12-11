#!/bin/sh

nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixos-25.11 nixos
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware 
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable 

