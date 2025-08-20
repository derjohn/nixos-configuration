{ config, pkgs, lib, ... }:

{
  # This is required so that pod can reach the API server (running on port 6443 by default)
  networking.firewall.allowedTCPPorts = [ 6443 ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
    # "--cluster-cidr=10.42.0.0/16,2a10:3781:25ac:2::/64 --service-cidr=10.43.0.0/16,2a10:3781:25ac:3::/112 --flannel-iface eno1"
    # "--no-deploy servicelb --no-deploy traefik --bind-address 192.168.51.1 --tls-san 192.168.51.1 --node-ip=192.168.51.1 --node-external-ip=192.168.51.1 --write-kubeconfig-mode 644"
    # "--disable-traefik";
    ];
  };

  systemd.services.k3s.wantedBy = lib.mkForce []; # disables k3s service by default

}

