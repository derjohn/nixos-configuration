#!/bin/sh

cp -v ~/.config/home-manager/home.nix ./home/.config/home-manager/home.nix
for i in $(ls etc/nixos); do
  sudo cat /etc/nixos/${i} > ./etc/nixos/${i}
done

