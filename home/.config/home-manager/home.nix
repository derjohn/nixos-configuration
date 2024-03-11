{ config, pkgs, libs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" ]; config.schuschu = "bubu"; };
  pkgs = import <nixpkgs> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" "libsciter" ]; };

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
    version = "6.7.0";
    src = fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
      sha256 = "sha256-X1wGrxwENEXKhJkY8cg0iFVJTnJzWDs/4jsluq01sZM=";
    };
  });
  # androidComposition = unstable.androidenv.androidPkgs_9_0.androidsdk;


#  androidComposition = pkgs.androidenv.composeAndroidPackages {
#    includeEmulator = true;
#    emulatorVersion = "30.9.0";
#  };
   temurin-bin-17-low = pkgs.temurin-bin-17.overrideAttrs(oldAttrs: { meta.priority = 10; });
   adoptopenjdk-hotspot-bin-15-low = pkgs.adoptopenjdk-hotspot-bin-15.overrideAttrs(oldAttrs: { meta.priority = 15; });
   adoptopenjdk-hotspot-bin-11-low = pkgs.adoptopenjdk-hotspot-bin-11.overrideAttrs(oldAttrs: { meta.priority = 30; });
   adoptopenjdk-hotspot-bin-8-low = pkgs.adoptopenjdk-hotspot-bin-8.overrideAttrs(oldAttrs: { meta.priority = 45; });

in

{
  programs.home-manager.enable = true;

  home.stateVersion = "21.05";
  home.username = "aj";
  home.homeDirectory = "/home/aj";

  home.packages = [ pkgs._3proxy pkgs.adoptopenjdk-icedtea-web pkgs.akonadi pkgs.android-tools pkgs.ansible pkgs.appimage-run pkgs.asdf-vm pkgs.autojump pkgs.avrdude pkgs.aws-mfa pkgs.awscli2 pkgs.azure-cli pkgs.azure-functions-core-tools pkgs.azure-storage-azcopy pkgs.bisq-desktop pkgs.brave pkgs.bruno pkgs.btop pkgs.byzanz pkgs.dart pkgs.dialog pkgs.docker-compose pkgs.dos2unix pkgs.drawio pkgs.drill pkgs.du-dust pkgs.ebusd pkgs.evince pkgs.ffmpeg-full pkgs.filezilla pkgs.firebase-tools pkgs.fluent-bit pkgs.fluxctl pkgs.freecad pkgs.freerdp pkgs.ghostscript pkgs.git-crypt pkgs.git-filter-repo pkgs.glibc pkgs.gmp pkgs.gnome-network-displays pkgs.go-ethereum pkgs.google-drive-ocamlfuse pkgs.gron pkgs.grpc-gateway pkgs.grpc-tools pkgs.grpcurl pkgs.gsctl pkgs.gsettings-desktop-schemas pkgs.handbrake pkgs.hugo pkgs.hugs pkgs.hunspell pkgs.hunspellDicts.de-de pkgs.hunspellDicts.en-us pkgs.imagemagick pkgs.insomnia pkgs.jameica pkgs.kalendar pkgs.kazam pkgs.kcalc pkgs.kdenlive pkgs.kphotoalbum pkgs.krusader pkgs.ktorrent pkgs.lapce pkgs.mediathekview pkgs.monero-gui pkgs.mosh pkgs.mupdf pkgs.mycrypto pkgs.nextcloud-client pkgs.nix-bundle pkgs.nixpkgs-fmt pkgs.nodejs pkgs.oathToolkit pkgs.ollama pkgs.onlyoffice-bin pkgs.openethereum pkgs.openshot-qt pkgs.openssl pkgs.outils pkgs.paperwork pkgs.pavucontrol pkgs.pdfarranger pkgs.pdfgrep pkgs.pdfsam-basic pkgs.pdsh pkgs.peek pkgs.pinta pkgs.pkgsCross.avr.buildPackages.gcc pkgs.platformio pkgs.postgresql_13 pkgs.proto-contrib pkgs.protoc-gen-go pkgs.protoc-gen-go-grpc pkgs.protoc-gen-validate pkgs.pssh pkgs.pwgen pkgs.python39Full pkgs.qpdf pkgs.rbenv pkgs.rclone pkgs.ripgrep pkgs.rpi-imager pkgs.rpl pkgs.rpmextract pkgs.ruby unstable.rustdesk-flutter pkgs.siege pkgs.signal-desktop pkgs.sipcalc pkgs.socat pkgs.sops pkgs.spectral pkgs.sshpass pkgs.sshuttle pkgs.swaks pkgs.unetbootin pkgs.untrunc pkgs.usbtop pkgs.viu pkgs.vscodium pkgs.wine pkgs.winetricks pkgs.x2goclient pkgs.xsel pkgs.xsv pkgs.yarn2nix pkgs.zip pkgs.zlib ferdiumLatest python39Packages.pip python39Packages.virtualenv temurin-bin-17-low adoptopenjdk-hotspot-bin-8-low adoptopenjdk-hotspot-bin-11-low adoptopenjdk-hotspot-bin-15-low (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin]) ];
  # nix-env -f .nix-defexpr/channels/nixos-unstable -iA signal-desktop
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.npm-global/bin"
  ];

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
    JAVA_8_HOME = "${adoptopenjdk-hotspot-bin-8-low}";
    JAVA_11_HOME = "${adoptopenjdk-hotspot-bin-11-low}";
    JAVA_15_HOME = "${adoptopenjdk-hotspot-bin-11-low}";
    JAVA_17_HOME = "${temurin-bin-17-low}";
    JAVA_HOME = "${adoptopenjdk-hotspot-bin-11-low}";
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
}
