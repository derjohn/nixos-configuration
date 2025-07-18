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
    kdePackages.kompare
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
    kdePackages.kwalletmanager
    kwalletcli
    kdePackages.kwallet-pam
    # ssh-add prompts a user for a passphrase using KDE. Not sure if it is used
    # by anything? ssh-add just asks passphrase on the console.
    #ksshaskpass
    kdePackages.ark
    kdePackages.kgpg
    pinentry-qt
    kdePackages.kdeplasma-addons
    kdePackages.dolphin-plugins
    kdePackages.qtvirtualkeyboard
    kdePackages.kcoreaddons
    kdePackages.kcmutils
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.kcmutils
    kdePackages.plasma-thunderbolt
    kdePackages.spectacle
    # bluedevil
    kdePackages.kate
    kdePackages.ktorrent
    kdePackages.yakuake
    simple-scan
    kdePackages.okular
    firefox
    tor
    kdePackages.gwenview
    gimp-with-plugins
    vlc
    kdePackages.konsole
    kdePackages.dolphin
    parted
    fatresize
    nmap
    # dd_rescue
    undervolt
    asdf
    kdePackages.kde-gtk-config
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
    # (pkgs.qemu_full.override { cephSupport = false; })
    qemu_kvm
    OVMFFull
    virtiofsd
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
    proxychains-ng
    openconnect
    networkmanager-openconnect
    ethtool
    atftp
    lynx
    w3m
    kdePackages.kmag
    libguestfs
    f2fs-tools
    docker-buildx
    psmisc
    bolt
    dislocker
    bpfmon
    bpftools
    bpftrace
    # miraclecast
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
    podman-compose
    lm_sensors
    vulkan-tools
    glxinfo
    gpu-viewer
    duplicati
    nextdns
    mdadm
    uefitool
    efibootmgr
    vulkan-tools
    clinfo
    zfs
    inxi
    ntfs3g
    globalprotect-openconnect
    weston
    libqmi
    uqmi
    modemmanager
    dhcpcd
    xorg.xev
    xorg.xhost
    wlr-randr
    wayland-utils
    dmenu
    libmbim
    maliit-keyboard
    maliit-framework
    CuboCore.corekeyboard
    onboard
    dconf
    glib
    dconf-editor
    exfat
    k3sup
    k3s
    linuxPackages_latest.cpupower
    # ( pkgs.chromium.override { commandLineArgs = "--enable-features=Vulkan --enable-unsafe-webgpu --use-angle=vulkan"; } )
    # ( pkgs.chromium.override { commandLineArgs = "chromium --enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,Vulkan --ignore-gpu-blocklist --enable-unsafe-webgpu --use-angle=vulkan"; } )
    ( pkgs.chromium.override { commandLineArgs = "chromium --enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder --ignore-gpu-blocklist --enable-unsafe-webgpu"; } )
  ];
}

