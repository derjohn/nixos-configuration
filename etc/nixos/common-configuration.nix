# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  variables       = import ./variables.nix;
  nixos-unstable  = import <nixos-unstable> { };
in

{
  imports =
    [ ./hardware-configuration.nix
      ./packages.nix
      ./k3s.nix
      <home-manager/nixos>
      ./vpn.nix
    ];

  #nix = {
  #  package = pkgs.nixFlakes;
    # extraOptions = ''
    #   experimental-features = nix-command flakes
    # '';
  # };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = lib.mkForce (pkgs.linuxPackages_lqx);
  # boot.kernelPackages = lib.mkForce (pkgs.linuxPackages_zen);
  # boot.kernelPackages = lib.mkForce (pkgs.linuxPackages_6_12);
  #boot.kernelParams = [ "vga=833" "intel_iommu=on" "nomodeset" ];
  boot.kernelParams = [ "vga=833" "intel_iommu=on" ];
  boot.supportedFilesystems = [ "ntfs" "ext4" "btrfs" "exfat" ];
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" "x86_64-windows" "i686-windows" ]; # for docker buildx and winehq
  hardware.enableRedistributableFirmware = true;

  # hardware.enableAllFirmware = true;
  # hardware.enableRedistributableFirmware = true;
  # nixpkgs.config.allowUnfree = true;

 services.journald.extraConfig = ''
   SystemMaxUse=2G
  '';
  # networking.hostName = "buckle"; # Define your hostname.
  # networking.hostId = "f00dcafe";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  powerManagement.powertop.enable = true;
  environment.etc.hosts.mode = "0644";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.enableIPv6 = true;
  networking.useDHCP = false;
  # networking.interfaces.enp0s13f0u1u1.useDHCP = true;
  # networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.dhcpcd.persistent = true;
  networking.dhcpcd.extraConfig = "";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties. I am kartoffel alman, but want technical stuff like system messages in english.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" "C.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    # LANG = "de_DE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_CTYPE="en_US.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    # LC_ALL = "C.UTF-8";
    # LC_ALL = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_COLLATE = "de_DE.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
  };

  console = {
    earlySetup = true;
    # font = "Lat2-Terminus16";
    font = "latarcyrheb-sun32";
    # keyMap = "de";
  };
  services.fprintd.enable = lib.mkForce false; # unfree binary !

  # See: https://github.com/NixOS/nixpkgs/blob/nixos-20.09/nixos/modules/security/sudo.nix
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120
  '';
  # security.sudo.wheelNeedsPassword = false;
  security.sudo.extraRules= [
    {  groups = [ "wheel" ];
      commands = [
        { command = "/run/current-system/sw/bin/systemctl status openvpn*"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop openvpn*"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start openvpn*"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl restart openvpn*"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

#  # Enable Sway (Wayland compositor)
#  programs.sway = {
#    enable = true;
#    wrapperFeatures.gtk = true; # For GTK theming
#    extraPackages = with pkgs; [
#      swaylock       # Lockscreen
#      swayidle       # Idle management
#      wl-clipboard   # Clipboard for Wayland
#      mako           # Notification daemon
#    ];
#  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.xserver.inputClassSections = [ ''
    Identifier         "disable secondary touchscreen inputs ILITEK ILITEK-TP"
    MatchIsTouchscreen "on"
    MatchProduct       "ILITEK ILITEK-TP"
    Option             "Ignore" "on"
  ''
  ''
    Identifier         "disable secondary touchscreen inputs ILITEK ILITEK-TP ILITEK ILITEK-TP Mouse"
    MatchIsTouchscreen "on"
    MatchProduct       "ILITEK ILITEK-TP Mouse"
    Option             "Ignore" "on"
  ''] ;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.hplip pkgs.splix pkgs.brlaser pkgs.ptouch-print ];
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "127.0.0.1:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network
  services.printing.allowFrom = [ "all" ]; # this gives access to anyone on the interface you might want to limit it see the official documentation
  services.printing.defaultShared = false; # If you want

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan pkgs.hplip nixos-unstable.utsushi];
  # unfree:pkgs.hplipWithPlugin pkgs.epkowa
  services.avahi = {
    enable   = true;
    nssmdns4 = true;
    wideArea = false;
    publish.enable = false;
    publish.userServices = false;
  };
  services.flatpak.enable = true;

  security.rtkit.enable = true;
  # Enable sound.
  # sound.enable = false;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    extraConfig.pipewire = {
      "99-switch-on-connect" = ''{
        context.modules = {
        { name = libpipewire-module-switch-on-connect }
      }
      '';
      "10-custom-rates" = ''{
      context.properties = {
        default.clock.rate = 44100;
        default.clock.allowed-rates = [ 44100 ];
      }
      '';
    };
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };

    wireplumber.extraConfig = {
      "10-jabra-rates.conf" = {
        monitor.alsa.rules = [
          {
            matches = [
              { node.name = "alsa_output.usb-Jabra_Jabra_Link_380-00.analog-stereo"; }
              { node.name = "alsa_input.usb-Jabra_Jabra_Link_380-00.analog-stereo"; }
            ];
            actions = {
              update-props = {
                audio.rate = 44100;
                # clock.rate = 44100;
                # clock.allowed-rates = "[ 44100 ]";
                # node.force-rate = 44100; # This is a direct force on the node
              };
            };
          }
        ];
      };
    };
  };
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "corefonts"
      ];

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      proggyfonts
      source-code-pro
      twitter-color-emoji
      terminus_font
      terminus_font_ttf
      gentium
      cantarell-fonts
      nerd-fonts.droid-sans-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Gentium Plus" ];
        sansSerif = [ "Cantarell" ];
        monospace = [ "Source Code Pro" ];
        emoji = [ "Twitter Color Emoji" ];
      };
      # Fixes pixelation
      antialias = true;

      # Fixes antialiasing blur
      hinting = {
        enable = true;
        style = "full"; # no difference
        autohint = true; # no difference
      };

      subpixel = lib.mkDefault {

        # Makes it bolder
        rgba = "rgb";
        lcdfilter = "default"; # no difference
      };
    };
  };

  # Define a user account. Don't forget to set a password with passwd
  users.users.aj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "podman" "libvirtd" "adbusers" "kvm" "qemu-libvirtd" "davfs2" "lxd" "scanner" "lp" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyOBlfvndGFyxcTuvo5kX+x9pJw1LCzf5ioflLnSSgK aj@net-lab.net john@systemdesign.net ajo@cloud-related.de Server-Management-Key" ];
    subUidRanges = [ { count = 10000; startUid = 1000000; } ];
    subGidRanges = [ { count = 10000; startGid = 1000000; } ];
  };

  users.users.ajzwo = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyOBlfvndGFyxcTuvo5kX+x9pJw1LCzf5ioflLnSSgK aj@net-lab.net john@systemdesign.net ajo@cloud-related.de Server-Management-Key" ];
    autoSubUidGidRange = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  # virtualisation.lxd.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.runAsRoot = true;
  users.groups.libvirtd.members = [ "root" "aj" ];
  # virtualisation.virtualbox.host.enable = true;
  #  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.waydroid.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.firejail.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };
  programs.bash.completion.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 20022 ];
  services.openssh.settings.X11Forwarding = true;
  programs.ssh.setXAuthLocation = true;
  programs.ssh.startAgent = true;

  # Firewall - enabled by default!
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 53 67 68 69 631 22000 21027 51820 51821 51822 53317 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
  networking.firewall.allowedTCPPorts = [ 53 69 631 22000 22222 11987 53317 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 32768; to = 60999; } ];
  networking.firewall.checkReversePath = "loose";
  networking.firewall.logReversePathDrops = true;
  networking.firewall.logRefusedConnections = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It is perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  services.openvpn.servers = {
    wpm   = { config = '' config /home/aj/.shared-configs/etc/openvpn/client/wpm.conf ''; autoStart = false; };
    rckt  = { config = '' config /home/aj/.shared-configs/etc/openvpn/client/rckt.conf ''; autoStart = false; };
    ajssl = { config = '' config /home/aj/.shared-configs/etc/openvpn/client/ajssl.conf ''; autoStart = false; };
    crnl  = { config = '' config /home/aj/.shared-configs/etc/openvpn/client/crnl.conf ''; autoStart = false; };
    # spare         = { config = '' config ''; };
  };

  services.davfs2.enable = true;
  services.autofs = {
    enable = true;
    debug = true;
    timeout = 600;
    autoMaster = let
      mapConf = pkgs.writeText "auto" variables.services.autofs.mapConfLines;
    in ''
      /home/aj/webdav file:${mapConf}
    '';
  };

  environment.sessionVariables = rec {
    PATH = [
      "\${HOME}/bin"
    ];
  };

  environment.shellAliases = {
    l = "ls -alh";
    ll = "ls -l";
    ls = "ls --color=tty";
    nix-search = "nix-env -qaP";
  };

  programs.nix-ld.enable = true;

  # environment.variables = {
  #     NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
  #       pkgs.stdenv.cc.cc
  #       pkgs.openssl
  #       # ...
  #     ];
  #     NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  # };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  system.activationScripts = {
    createSymlimks = {
      text = ''
      # Needed by some programs.
      ln -sfn /proc/self/fd /dev/fd
      ln -sfn /proc/self/fd/0 /dev/stdin
      ln -sfn /proc/self/fd/1 /dev/stdout
      ln -sfn /proc/self/fd/2 /dev/stderr
      ln -sfn /run/current-system/sw/bin/bash /bin/bash
      ## mkdir -p /lib64
      ## ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
      # ln -sfn /nix/store/xxxxxxxxxxxxxxxxxxxxxxx-glibc-2.33-56/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
      '';
    };
  };

  home-manager.useGlobalPkgs = true;
  programs.adb.enable = true;
  programs.kdeconnect.enable = true;
  ## android_sdk.accept_license = true;

  # Render /etc/current-system-packages
  environment.etc."current-system-packages".text =
  let
  packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
  formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
  formatted;


  services._3proxy = {
    enable = true;
    services = [
      {
        type = "proxy";
          auth = [ "strong" ];
          acl = [ {
            rule = "allow";
            users = [ "proxy" ];
          }
        ];
        bindAddress = "127.0.0.1";
        bindPort = 3128;
        maxConnections = 128;
        extraConfig = variables._3proxy.extraConfig;
      }
    ];
    usersFile = "/etc/3proxy.passwd";
  };

  environment.etc."3proxy.passwd".text = variables._3proxy.passwd;

  networking.extraHosts = variables.networking.extraHosts;

  services.atftpd.enable = true;
  services.atftpd.extraOptions = [
    "--bind-address 0.0.0.0"
    "--verbose=7"
  ];
  services.atftpd.root = "/srv/tftp";
}

