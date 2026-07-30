{ config, pkgs, libs, ... }:

#with pkgs;
let
  unstable = import <nixos-unstable> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "android_sdk" ]; config.permittedInsecurePackages = [ "olm-3.2.16" "mbedtls-2.28.10" ]; };

  ferdiumLatest = pkgs.ferdium.overrideAttrs (oldAttrs: rec {
  #hash =
  #  {
  #    x86_64-linux = "sha256-ODQKFjBa2riJY26aPaAfLzuCyLYkB5oYSxIE28nMmwY=";
  #    aarch64-linux = "sha256-CYHoTw6JUyU63iTd9tAbfWVnb48WcZgGtjthqnlAD8I=";
  #  }
    version = "7.1.3-nightly.3";
    src = pkgs.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
      sha256 = "sha256-FauUQO3FucLpIKxGAalCaD5jPAajXPR1X4yXHBmzqMI=";
    };
  });

  # pkgs = import <nixpkgs> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" "libsciter" ]; config.permittedInsecurePackages = [ "olm-3.2.16" "mbedtls-2.28.10" "gradle-7.6.6" ]; };

   temurin-bin-21-low = pkgs.temurin-bin-21.overrideAttrs(oldAttrs: { meta.priority = 21; });
   ## temurin-bin-17-low = pkgs.temurin-bin-17.overrideAttrs(oldAttrs: { meta.priority = 17; });
   ## temurin-bin-8-low = pkgs.temurin-bin-8.overrideAttrs(oldAttrs: { meta.priority = 8; });

   phpstuff = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ all.imagick ]);
   # phpstuff = (php.withExtensions ({ all, enabled }: enabled ++ (with all; [ imagick redis ]))).packages.composer;
   # openjfx_jdk = pkgs.openjfx.override { withWebKit = true; };
in

{
  nixpkgs.config = { android_sdk.accept_license = true; allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "android_sdk" "libsciter" ]; permittedInsecurePackages = [ "olm-3.2.16" "mbedtls-2.28.10" "gradle-7.6.6" "qtwebengine-5.15.19" ]; };

  # nixpkgs.overlays = [
  #   (import ./overlays/freerdp2.nix)
  # ];

  # programs.home-manager.enable = true;
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home.stateVersion = "21.05";
  home.username = "aj";
  home.homeDirectory = "/home/aj";
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.npm-global/bin"
  ];

  xdg.enable = true;
  xdg.configFile."maliit.org/server.conf".text = ''
    [org.maliit.keyboard]
    activeLanguage=de
    enabledLanguages=de,us
  '';
  xdg.configFile."plasma-localerc".source = pkgs.writeText "plasma-localerc" ''
    [Formats]
    LANG=en_US.UTF-8
    LC_ADDRESS=de_DE.UTF-8
    LC_MEASUREMENT=de_DE.UTF-8
    LC_MONETARY=de_DE.UTF-8
    LC_NAME=de_DE.UTF-8
    LC_NUMERIC=de_DE.UTF-8
    LC_PAPER=de_DE.UTF-8
    LC_TELEPHONE=de_DE.UTF-8
    LC_TIME=de_DE.UTF-8
    LC_COLLATE=de_DE.UTF-8
  '';
  xdg.configFile."plasma-localerc".force = true;

  home.file."${config.xdg.dataHome}/applications/ferdium-second.desktop" = {
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=Ferdium Special Browser Options
      Exec=ferdium --enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder --ignore-gpu-blocklist
      Icon=ferdium
      Terminal=false
      Type=Application
      Categories=Network;InstantMessaging;
    '';
    executable = true;
  };

  programs.tirith.enable = true;
  programs.command-not-found.enable = true;
  programs.andcli.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "derjohn";
      user.email = "himself@derjohn.de";
      aliases = {
        st = "status";
        praise = "blame";
      };
      core.askpass = "";
      signing.format = "openpgp";
    };
    # git config --global --unset core.askpass
    # git config credential.helper 'cache --timeout=1
    # check: git config --list'
  };

  programs.go.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc.extra
    '';
    initExtra = ''
      . "${pkgs.asdf-vm}/etc/profile.d/asdf-prepare.sh"
      . "${pkgs.asdf-vm}/share/bash-completion/completions/asdf.bash"
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      # export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.nix-direnv.enableFlakes = true;
  programs.zsh.enable = true;
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.autojump.enable = true;
  programs.java = {
    enable = true;
  };

  home.sessionVariables = {
    # PYTHONPATH = "${python-with-my-packages}/${python-with-my-packages.sitePackages}";
    # ANDROID_SDK_ROOT = "${androidComposition}/libexec/android-sdk";
    # ANDROID_NDK_ROOT = "\${ANDROID_SDK_ROOT}/ndk-bundle";
    EDITOR="vim";
    JAVA_21_HOME = "${temurin-bin-21-low}/lib/openjdk";
    NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      pkgs.openssl
      pkgs.zlib
      pkgs.gmp
    ];
    NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/run/current-system/sw/share";
  };

  programs.vim = {
    enable = true;
    # extraConfig = builtins.readFile vim/vimrc.vim;
    extraConfig = ''
      set mouse=v
      set nonumber
    '';
    settings = { number = true; };
    plugins = with pkgs.vimPlugins; [ vim-airline nerdtree vim-better-whitespace ];
  };

#  programs.neovim = {
#    enable = true;
#    viAlias = false;
#    vimAlias = false;
#    extraConfig = ''
#      set number relativenumber
#      set mouse=v
#    '';
#    withPython3 = true;
#    withRuby = true;
#    # withNodeJs = false;
#
#    # extraPackages = with pkgs; [
#    #   python3Packages.flake8
#    # ];
#  };

  programs.looking-glass-client.enable = true;

  programs.nvchecker = {
    enable = true;
    settings = {
      ferdium = {
        source = "github";
        github = "ferdium/ferdium-app";
      };
    };
  };

  dconf.settings."org/maliit/keyboard/maliit" = {
    enabled-languages = [
      "en"
      "de"
    ];
    device = "tablet";
  };

  home.packages = with pkgs; [
    (lib.hiPrio localsend)
    _3proxy
    adoptopenjdk-icedtea-web
    age
    amberol
    android-tools
    ansible
    antimicrox
    appimage-run
    arduino-cli
    asdf-vm
    autojump
    avrdude
    aws-mfa
    awscli
    azure-cli
    bruno
    byzanz
    cadaver
    cheese
    chntpw
    darktable
    dfu-programmer
    dfu-util
    dialog
    digikam
    dos2unix
    drill
    dust
    ebusd
    envsubst
    evince
    exo
    ferdium
    # ferdiumLatest
    ffmpeg-full
    filezilla
    fluent-bit
    fprintd
    freerdp
    gh
    ghostscript
    ghostty
    git-crypt
    git-filter-repo
    glibc
    glow
    gmp
    gnome-network-displays
    go-ethereum
    google-drive-ocamlfuse
    gron
    grpc-gateway
    grpc-tools
    grpcurl
    gsctl
    gsettings-desktop-schemas
    handbrake
    hidapi
    hugo
    hunspell
    hunspellDicts.de-de
    hunspellDicts.de_DE
    hunspellDicts.en-us
    hydra-check
    hyphen
    imagemagick
    insomnia
    ipmitool
    john
    johnny
    kazam
    kdePackages.akonadi
    kdePackages.kcalc
    kdePackages.kteatime
    kdePackages.ktorrent
    kdePackages.neochat
    kdePackages.qtvirtualkeyboard
    keepassxc
    kphotoalbum
    krusader
    lapce
    libnotify
    libreoffice-fresh
    librewolf
    linphone
    lxqt.pcmanfm-qt
    mediathekview
    molly-guard
    monero-gui
    mosh
    mpv
    mupdf
    mycrypto
    neo-cowsay
    nextcloud-client
    nextcloud-talk-desktop
    nix-bundle
    nixpkgs-fmt
    nodejs_26
    oath-toolkit
    ocrmypdf
    ollama
    onlyoffice-desktopeditors
    openjfx
    openssl
    openstackclient
    outils
    paperwork
    pavucontrol
    pdf4qt
    pdfarranger
    pdfgrep
    pdfsam-basic
    pdsh
    peek
    pgadmin4-desktopmode
    pinta
    pkgsCross.avr.buildPackages.gcc
    platformio
    playwright
    playwright-driver
    poppler-utils
    postgresql_16
    proto-contrib
    protoc-gen-go
    protoc-gen-go-grpc
    protoc-gen-validate
    pssh
    pwgen
    python313
    qpdf
    qrencode
    quba
    rbenv
    rclone
    redocly
    reptyr
    ripgrep
    rpl
    rpmextract
    ruby
    rustdesk-flutter
    s3cmd
    unstable.signal-cli
    signal-desktop
    simplex-chat-desktop
    sipcalc
    socat
    sops
    speedtest-cli
    sshpass
    sshuttle
    stoken
    swaks
    teams-for-linux
    thunderbird-esr
    tigervnc
    unetbootin
    usbtop
    viu
    vscodium
    winetricks
    x2goclient
    xan
    xdotool
    xhost
    xournalpp
    xsel
    ydotool
    zip
    zlib
    delve
    unstable.jameica
  ];
  # pkgs.azure-functions-core-tools pkgs.azure-storage-azcopy
  # pkgs.python313Packages.pip pkgs.python313Packages.virtualenv temurin-bin-21-low  pkgs.python313 pkgs.insomnia  pkgs.onlyoffice-desktopeditors pkgs.opencode unstable.ferdium pkgs.rustdesk-flutter  kgs.kdePackages.kdenlive pkgs.freecad pkgs.libreoffice-fresh pkgs.vscodium pkgs.gsettings-qt pkgs.teams-for-linux
  # (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]) phpstuff
  # unstable.hoppscotch
  # nix-env -f .nix-defexpr/channels/nixos-unstable -iA signal-desktop
}
