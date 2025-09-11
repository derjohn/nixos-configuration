#!/bin/sh

cp -v ./home/.config/home-manager/home.nix ~/.config/home-manager/home.nix
for i in $(find etc/nixos -type d); do
  sudo mkdir -vp /${i}
done
for i in $(find etc/nixos -type f); do
  sudo cp ${i} /${i}
done

