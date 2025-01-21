#!/bin/sh

cp -v ~/.config/home-manager/home.nix ./home/.config/home-manager/home.nix
for i in $(find etc/nixos -type f); do
  sudo cat /${i} > ${i}
done

