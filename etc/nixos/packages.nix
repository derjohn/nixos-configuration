{ libs, config, pkgs, ... }:


{
  # pkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "corefonts" ];
  environment.systemPackages = with pkgs; [
    nix-index
    usbutils
    pciutils
    pavucontrol
    wpa_supplicant
    vim
    wget
    tcpdump
    curl
    openvpn
    wireguard-tools
    softether
    nextcloud-client
    git
    openssl
    netcat-gnu
    freerdp
    mtr
    tcpdump
    asdf
    direnv
    gimp
    inkscape
    jq
    kdiff3
    kompare
    krename
    krita
    krusader
    syncthing
    syncthingtray
    vlc
    # vscodium
    yq
    virt-manager
    virt-top
    virt-viewer
    pipewire
    zsh-history
    zsh-git-prompt
    zsh-nix-shell
    zsh-autoenv
    zsh
    vimPlugins.deoplete-zsh
    oh-my-zsh
    nix-zsh-completions
    hexchat
    pipewire
    tmux
    gparted
    nix-prefetch-scripts
    btrfs-progs
    terminus_font
    terminus_font_ttf
    iptraf-ng
    # networkmanager-qt
    openvpn
    kwalletmanager
    kwalletcli
    kwallet-pam
    # ssh-add prompts a user for a passphrase using KDE. Not sure if it is used
    # by anything? ssh-add just asks passphrase on the console.
    #ksshaskpass
    ark
    kgpg
    pinentry-qt
    kdeplasma-addons
    kdePackages.dolphin-plugins
    plasma-thunderbolt
    spectacle
    bluedevil
    kate
    ktorrent
    yakuake
    simple-scan
    okular
    firefox
    chromium
    tor 
    gwenview
    digikam
    gimp-with-plugins
    vlc
    konsole
    kdePackages.dolphin
    parted
    fatresize
    nmap
    dd_rescue
    undervolt
    asdf
    kde-gtk-config
    materia-theme
    arc-icon-theme
    arc-kde-theme
    arc-theme
    adapta-kde-theme
    pavucontrol
    gnumake
    freerdp
    mc
    ncdu
    qemu-utils
    qemu_full
    libvirt
    file
    inetutils
    iw
    screen
    tmux
    foomatic-filters
    home-manager
    powertop
    dmidecode
    davfs2
    glances
    bind
    sysstat
    iotop
    ptouch-print    
    psutils
    glibc
    patchelf
    binutils
    stdenv
    dpkg
    nix-index
    stdenv.cc
    killall
    lm_sensors
    unzip
    libguestfs
    oathToolkit
    # rpl
    brightnessctl
    apacheHttpd
    p7zip
    smartmontools
    hdparm
    libva-utils
    intel-gpu-tools
    libguestfs
    multipath-tools
    ubootTools
    lshw
    openfortivpn
    openconnect
    networkmanager-openconnect
    openconnect_openssl
    restic
    autorestic
    proxychains
    openconnect
    networkmanager-openconnect
    ethtool
    atftp
    lynx
    w3m
    kmag
    libguestfs
    f2fs-tools
    docker-buildx
    psmisc
    bolt
    dislocker
    bpfmon
    bpftools
    bpftrace
    miraclecast
    memtester
    nvme-cli
    libinput
    xlibinput-calibrator
    libinput
    libinput-gestures
    appimage-run
    lsof
    dive
    podman-tui
    docker-compose
    podman-compose
    lm_sensors
    vulkan-tools
    glxinfo
    gpu-viewer
    duplicati
    nextdns
  ];
}

