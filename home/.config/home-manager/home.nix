{ config, pkgs, libs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" ]; config.permittedInsecurePackages = [ "olm-3.2.16" "mbedtls-2.28.10" ]; };
  pkgs = import <nixpkgs> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" "libsciter" ]; config.permittedInsecurePackages = [ "olm-3.2.16" "mbedtls-2.28.10" ]; };

  # my-python-packages = python-packages: with python-packages; [
  #   pip
  #   bluepy
  #   bluepy-devices
  #   # cometblue-lite
  #   bsdiff4
  #   protobuf
  #   chardet
  # ];
  ### python-with-my-packages = unstable.python3.withPackages my-python-packages;
  # python-with-my-packages = pkgs.python3.withPackages my-python-packages;
  ferdiumLatest = pkgs.ferdium.overrideAttrs (oldAttrs: rec {
    version = "7.1.1";
    src = fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
      sha256 = "sha256-1jXo8MMk2EEkLo0n4ICmGJteKProLYKkMF//g63frHs=";
    };
  });

  # androidComposition = unstable.androidenv.androidPkgs_9_0.androidsdk;


#  androidComposition = pkgs.androidenv.composeAndroidPackages {
#    includeEmulator = true;
#    emulatorVersion = "30.9.0";
#  };
   temurin-bin-21-low = pkgs.temurin-bin-21.overrideAttrs(oldAttrs: { meta.priority = 21; });
   temurin-bin-17-low = pkgs.temurin-bin-17.overrideAttrs(oldAttrs: { meta.priority = 17; });
   temurin-bin-8-low = pkgs.temurin-bin-8.overrideAttrs(oldAttrs: { meta.priority = 8; });

   phpstuff = pkgs.php.withExtensions ({ enabled, all }: enabled ++ [ all.imagick ]);
   # phpstuff = (php.withExtensions ({ all, enabled }: enabled ++ (with all; [ imagick redis ]))).packages.composer;
   # openjfx_jdk = pkgs.openjfx.override { withWebKit = true; };
in

{
  programs.home-manager.enable = true;

  home.stateVersion = "21.05";
  home.username = "aj";
  home.homeDirectory = "/home/aj";
  # pkgs.azure-functions-core-tools pkgs.azure-storage-azcopy
  home.packages = [ pkgs._3proxy pkgs.adoptopenjdk-icedtea-web pkgs.age pkgs.kdePackages.akonadi pkgs.android-tools pkgs.ansible pkgs.antimicrox pkgs.appimage-run pkgs.arduino-cli pkgs.asdf-vm pkgs.autojump pkgs.avrdude pkgs.aws-mfa pkgs.awscli2 pkgs.azure-cli pkgs.barman pkgs.brave pkgs.bruno pkgs.btop pkgs.byzanz pkgs.cadaver pkgs.cheese pkgs.chntpw pkgs.neo-cowsay pkgs.dart pkgs.darktable pkgs.dfu-util pkgs.dfu-programmer unstable.delve pkgs.dialog pkgs.dos2unix pkgs.drill pkgs.du-dust pkgs.ebusd pkgs.envsubst pkgs.evince pkgs.exo pkgs.ffmpeg-full pkgs.filezilla pkgs.firebase-tools pkgs.fluent-bit pkgs.freecad pkgs.freerdp pkgs.gh pkgs.ghostscript pkgs.git-crypt pkgs.git-filter-repo pkgs.glibc pkgs.gmp pkgs.gnome-network-displays pkgs.gsettings-qt pkgs.go-ethereum pkgs.google-drive-ocamlfuse pkgs.goose-cli pkgs.gron pkgs.grpc-gateway pkgs.grpc-tools pkgs.grpcurl pkgs.gsctl pkgs.gsettings-desktop-schemas pkgs.handbrake pkgs.hugo pkgs.hidapi pkgs.hunspell pkgs.hunspellDicts.de-de pkgs.hunspellDicts.en-us pkgs.hunspellDicts.de_DE pkgs.hyphen pkgs.imagemagick pkgs.insomnia pkgs.ipmitool pkgs.jameica pkgs.john pkgs.johnny pkgs.kazam pkgs.kdePackages.kcalc pkgs.kdePackages.kdenlive kdePackages.qtvirtualkeyboard pkgs.keepassxc pkgs.kphotoalbum pkgs.krusader pkgs.kdePackages.kteatime pkgs.kdePackages.ktorrent pkgs.lapce pkgs.libnotify pkgs.libreoffice-fresh pkgs.librewolf (lib.hiPrio pkgs.localsend) pkgs.linphone pkgs.lxqt.pcmanfm-qt pkgs.mediathekview pkgs.molly-guard pkgs.monero-gui pkgs.mosh pkgs.mpv pkgs.mupdf pkgs.mycrypto pkgs.nextcloud-client pkgs.nix-bundle pkgs.nixpkgs-fmt pkgs.nodejs pkgs.oathToolkit pkgs.ocrmypdf pkgs.ollama pkgs.onlyoffice-bin pkgs.openjfx pkgs.openshot-qt pkgs.openssl pkgs.openstackclient pkgs.outils pkgs.paperwork pkgs.pavucontrol pkgs.pdf4qt pkgs.pdfarranger pkgs.pdfgrep pkgs.pdfsam-basic pkgs.pdsh pkgs.peek pkgs.pgadmin4-desktopmode pkgs.poppler-utils pkgs.pinta pkgs.pkgsCross.avr.buildPackages.gcc pkgs.platformio pkgs.playwright pkgs.playwright-driver pkgs.postgresql_16 pkgs.proto-contrib pkgs.protoc-gen-go pkgs.protoc-gen-go-grpc pkgs.protoc-gen-validate pkgs.pssh pkgs.pwgen pkgs.python3Full unstable.quba pkgs.qpdf pkgs.qrencode pkgs.rbenv pkgs.rclone pkgs.redocly-cli pkgs.regclient pkgs.regsync pkgs.ripgrep pkgs.rpl pkgs.rpmextract pkgs.ruby pkgs.rustdesk-flutter pkgs.s3cmd pkgs.siege pkgs.signal-desktop-bin pkgs.simplex-chat-desktop pkgs.sipcalc pkgs.socat pkgs.sops pkgs.speedtest-cli pkgs.kdePackages.neochat pkgs.sshpass pkgs.sshuttle pkgs.stoken pkgs.swaks pkgs.thunderbird-140 pkgs.tigervnc pkgs.unetbootin pkgs.untrunc-anthwlock pkgs.usbtop pkgs.viu unstable.vscodium pkgs.wineWowPackages.stable pkgs.winetricks pkgs.wireshark pkgs.x2goclient pkgs.xdotool pkgs.xorg.xhost pkgs.xsel pkgs.xan pkgs.yarn2nix pkgs.ydotool pkgs.zip pkgs.zlib python3Packages.pip python3Packages.virtualenv temurin-bin-17-low temurin-bin-21-low (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin]) phpstuff ferdiumLatest ];
  # unstable.hoppscotch
  # nix-env -f .nix-defexpr/channels/nixos-unstable -iA signal-desktop
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

  programs.command-not-found.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.git = {
    enable = true;
    userName = "derjohn";
    userEmail = "himself@derjohn.de";
    aliases = {
      st = "status";
      praise = "blame";
    };
    extraConfig = {
      core.askpass = "";
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
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.nix-direnv.enableFlakes = true;
  programs.zsh.enable = true;
  programs.autojump.enable = true;
#  programs.java = {
#    enable = true;
#    package = pkgs.jdk8;
#  };

  home.sessionVariables = {
    # PYTHONPATH = "${python-with-my-packages}/${python-with-my-packages.sitePackages}";
    # ANDROID_SDK_ROOT = "${androidComposition}/libexec/android-sdk";
    # ANDROID_NDK_ROOT = "\${ANDROID_SDK_ROOT}/ndk-bundle";
    EDITOR="vim";
    JAVA_17_HOME = "${temurin-bin-17-low}/lib/openjdk";
    JAVA_21_HOME = "${temurin-bin-21-low}/lib/openjdk";
    JAVA_HOME = "${temurin-bin-21-low}/lib/openjdk";
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      pkgs.openssl
      pkgs.zlib
      pkgs.gmp
    ];
    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
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

  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    extraConfig = ''
      set number relativenumber
      set mouse=v
    '';
    withPython3 = true;
    withRuby = true;
    withNodeJs = false;

    extraPackages = with pkgs; [
      python3Packages.flake8
    ];
  };

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

}
