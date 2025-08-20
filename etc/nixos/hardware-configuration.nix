{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "ftdi_sio" "coretemp" ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  boot.kernelParams = [ "vga=833" "intel_iommu=on" ];
  # boot.kernelParams = [ "i915.force_probe=9a49" ]; ## force only needed from Gen12 onwards (I have Gen 11)
  # boot.kernelParams = [ "i915.enable_psr=0" "i915.force_probe=9a49" ]; ## disabled 6.7.2 02/2024
  # boot.kernelParams = [ "i915.force_probe=9a49" ];
  # boot.kernelParams = [ "i915.enable_psr=0" ];
  # boot.kernelParams = [ "i915.enable_psr=1" "i915.enable_guc_loading=1" "i915.enable_guc_submission=1" ];
  #  boot.kernelParams = [
  #    "pcie.aspm=force"
  #    "i915.enable_fbc=1"
  #    "i915.enable_rc6=7"
  #    "i915.lvds_downclock=1"
  #    "i915.enable_guc_loading=1"
  #    "i915.enable_guc_submission=1"
  #    "i915.enable_psr=0"
  #  ];
  boot.extraModprobeConfig = ''
options snd-hda-intel model=alc288-dell-xps13 sdhci
# options snd_hda_intel power_save=1
'';

  boot.initrd.luks.devices.luksroot = {
    allowDiscards = true;
    # device = "/dev/nvme0n1p5";
    device = "/dev/disk/by-partlabel/luks";
    preLVM = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.sensor.iio.enable = true;

  # environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  # environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
  # libva-intel-driver/vaapiIntel: i965 intel-media-driver: iHD
  hardware.acpilight.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.i2c.enable = true;
  programs.coolercontrol = {
    enable = false;
    nvidiaSupport = false;
  };
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = null; # will be managed by tlp
  services.power-profiles-daemon.enable = false;
  services.hardware.bolt.enable = true;
  services = {
    tlp = {
      enable = true;
      settings = {
        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        START_CHARGE_THRESH_BAT0="55";
        STOP_CHARGE_THRESH_BAT0="80";
        CPU_SCALING_GOVERNOR_ON_AC="powersave";
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        MAX_LOST_WORK_SECS_ON_AC="15";
        MAX_LOST_WORK_SECS_ON_BAT="60";
        CPU_MAX_PERF_ON_AC="100";
        CPU_MAX_PERF_ON_BAT="75";
        CPU_ENERGY_PERF_POLICY_ON_AC="performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT="balance_performance";
        USB_AUTOSUSPEND="1";
        USB_DENYLIST="4242:4242 1337:1337";
        USB_EXCLUDE_AUDIO="1";
        USB_EXCLUDE_BTUSB="1";
        USB_EXCLUDE_WWAN="0";
      };
    };
    upower.enable = true;
    # upower -i $(upower -e | grep 'BAT')
    dbus.packages = with pkgs; [
      maliit-framework
      miraclecast
    ];
  };
  hardware.usb-modeswitch.enable = true;
  services.fstrim.enable = true;
  services.udev.packages = with pkgs; [
    utsushi
    usb-modeswitch-data
    platformio-core
    openocd
  ];
  services.udev.extraRules = lib.mkBefore ''
    # Flexbox rules
    #V2 Legacy
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5750", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5750", MODE="0666"
    #V2
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="[aA]0[eE]7", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="[aA]0[eE]7", MODE="0666"
    #V3
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="[aA]0[eE]8", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="[aA]0[eE]8", MODE="0666"
    #V4  16D0 0B1A
    SUBSYSTEM=="usb", ATTR{idVendor}=="16[dD]0", ATTR{idProduct}=="0[bB]1[aA]", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="16[dD]0", ATTRS{idProduct}=="0[bB]1[aA]", MODE="0666"
  '';
}

