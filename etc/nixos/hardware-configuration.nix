# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "i915.enable_psr=0" ];
  boot.extraModprobeConfig = ''
options snd-hda-intel model=alc288-dell-xps13
# options snd_hda_intel power_save=1
'';

  boot.initrd.luks.devices.luksroot = {
    allowDiscards = true;
    # device = "/dev/nvme0n1p5";
    device = "/dev/disk/by-partlabel/luks";
    preLVM = true;
  };
   
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f088559d-aaca-48db-9c5c-52bdfe025c06";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

#   fileSystems."/boot" =
#     { device = "/dev/disk/by-uuid/CB58-328D";
#       fsType = "vfat";
#     };

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

  # /dev/mapper/vg-swap: UUID="b903769b-651f-4d5f-9688-299c986a2c64" TYPE="swap"
  swapDevices = [ { device = "/dev/disk/by-uuid/b903769b-651f-4d5f-9688-299c986a2c64"; } ];

  powerManagement.cpuFreqGovernor = "powersave";

  hardware.bluetooth.enable = true;

  # high-resolution display
  hardware.video.hidpi.enable = true;
  hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
  };

  powerManagement.enable = true;
  services = {
    tlp = {
      enable = true;
      settings = {
      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        START_CHARGE_THRESH_BAT0="75";
        STOP_CHARGE_THRESH_BAT0="80";
        CPU_SCALING_GOVERNOR_ON_AC="performance";
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        # 100 being the maximum, limit the speed of my CPU to reduce
        # heat and increase battery usage:
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=75;
      };
    };
    upower.enable = true;
    dbus.packages = with pkgs; [
      miraclecast
    ];
    avahi = {
      enable = true;
      nssmdns = true;
      wideArea = false;
    };
  };
}
