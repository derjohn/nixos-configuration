#!/bin/sh

cp -v ~/.config/nixpkgs/home.nix ./home/.config/nixpkgs/home.nix
for i in $(ls etc/nixos); do
  sudo cat /etc/nixos/${i} > ./etc/nixos/${i}
done

