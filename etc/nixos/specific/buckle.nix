{ config, lib, pkgs, modulesPath, ... }:

{
  networking.hostName = "buckle"; # Define your hostname.
  networking.hostId = "f00dcafe";

  boot.extraModprobeConfig = ''
options snd-hda-intel model=alc288-dell-xps13 sdhci
# options snd_hda_intel power_save=1
'';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f088559d-aaca-48db-9c5c-52bdfe025c06";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/B776-B3E2";
      fsType = "vfat";
    };

  # /dev/mapper/vg-home: UUID="9b79d0d6-a468-4960-b515-85d41a4b49db" UUID_SUB="1a2986a5-4c72-4e0b-aa5e-6dd1cd52179e" BLOCK_SIZE="4096" TYPE="btrfs"
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9b79d0d6-a468-4960-b515-85d41a4b49db";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" "nodiratime" "discard" ];
    };

  swapDevices = [ ];
  # zramctl to check compression
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 20;
  };

  # nix-shell -p libva-utils --run vainfo
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true; # for wine with openGL
    # setLdLibraryPath = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt # Use vpl-gpu-rt instead of onevpl-intel-gpu > nixos 24.05 and tiger lake (11gen)
      pkgs.mesa.drivers
      vulkan-loader
      vulkan-tools
    ];

  };

  services.thermald = {
    debug = true;
    enable = true;
    configFile = "/etc/nixos/thermal-conf-handcrafted.xml";
  };

}
