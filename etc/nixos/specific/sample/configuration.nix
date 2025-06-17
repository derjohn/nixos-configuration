{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./filesystems.nix
  ];

  networking.hostName = "sample"; # Define your hostname.
  networking.hostId = "f00dcafeb33f";
}

