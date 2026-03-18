# Update Channels

```
./nix-channels.sh
```

# Update flakes

```
nix flake update

```
# Rebuild with flake

```
sudo nixos-rebuild switch --flake .

```
# Repair the nix-store

```
nix-store --verify --check-contents --repair

```

