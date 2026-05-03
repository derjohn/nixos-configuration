# Update Channels

```
./nix-channels.sh
# needed for nix-shell -p and home-manager
```

# Update flakes

```
nix flake update /etc/nixos

```
# Rebuild with flake

```
sudo nixos-rebuild switch --flake /etc/nixos

```
# Repair the nix-store

```
nix-store --verify --check-contents --repair

```

