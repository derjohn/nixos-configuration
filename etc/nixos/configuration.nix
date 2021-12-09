# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./k3s.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "vga=833" ];

  # hardware.enableAllFirmware = true;
  # nixpkgs.config.allowUnfree = true;

  networking.hostName = "buckle"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s13f0u1u1.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_CTYPE="en_US.UTF-8";
    #LC_TIME = "de_DE.UTF-8";
    #LC_CTYPE="de_DE.UTF-8";
  };

  console = {
    earlySetup = true;
    # font = "Lat2-Terminus16";
    font = "latarcyrheb-sun32";
    keyMap = "de";
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120
  '';

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.hplip pkgs.splix pkgs.brlaser pkgs.ptouch-print ];

  services.avahi.enable = true;
  services.avahi.publish.enable = false;
  services.avahi.publish.userServices = false;
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "127.0.0.1:631" ]; # Not 100% sure this is needed and you might want to restrict to the local network
  services.printing.allowFrom = [ "all" ]; # this gives access to anyone on the interface you might want to limit it see the official documentation
  services.printing.defaultShared = false; # If you want

  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  # Enable sound.
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "corefonts"
      ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ 
      corefonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts
      dina-font
      proggyfonts
      terminus_font
      terminus_font_ttf
      nerdfonts
    ];
  };

  programs.bash.enableCompletion = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aj = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyOBlfvndGFyxcTuvo5kX+x9pJw1LCzf5ioflLnSSgK aj@net-lab.net john@systemdesign.net ajo@cloud-related.de Server-Management-Key" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 20022 ];
  programs.ssh.startAgent = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  services.openvpn.servers = {
    wpm   = { config = '' config .shared-configs/etc/openvpn/openvpn_wpm.conf ''; };
    ajssl = { config = '' config .shared-configs/etc/openvpn/aj.sslvpn.services.net-lab.net.conf ''; };
    crnl  = { config = '' config .shared-configs/etc/openvpn/client/crnl.conf ''; };
    kmo   = { config = '' config .shared-configs/etc/openvpn/client/kmo.conf ''; };
    # spare         = { config = '' config ''; };
  };

  services.davfs2.enable = true;
#  services.autofs = {
#    enable = true;
#    autoMaster = let
#      mapConf = pkgs.writeText "auto" ''
#        nextcloud -fstype=davfs,conf=/home/aj/.config/davfs2/conf,uid=aj :https\:nextcloud.cloud-related.de/remote.php/webdav/
#      '';
#    in ''
#      /home/aj/secrets-nextcloud file:${mapConf}
#    '';
#  };

#My davfs2.conf contains
#
#secrets /home/directory/.config/davfs2/secrets
#...and the secrets file has
#
#https://nextcloud.domain/remote.php/webdav/ username password

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

  system.activationScripts = {
    createSymlimks = {
      text = ''
      # Needed by some programs.
      ln -sfn /proc/self/fd /dev/fd
      ln -sfn /proc/self/fd/0 /dev/stdin
      ln -sfn /proc/self/fd/1 /dev/stdout
      ln -sfn /proc/self/fd/2 /dev/stderr
      ln -sfn /run/current-system/sw/bin/bash /bin/bash
      mkdir -p /lib64
      ln -sfn /nix/store/z56jcx3j1gfyk4sv7g8iaan0ssbdkhz1-glibc-2.33-56/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
      '';
    };
  };
}

