# Update Channels

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixos-24.11 nixos
```

# Set UUID
echo -n $(cat /sys/devices/virtual/dmi/id/product_uuid) > /etc/nixos/machine-id

