{ config, pkgs, libs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" ]; config.schuschu = "bubu"; };
  pkgs = import <nixpkgs> { config.android_sdk.accept_license = true; config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "android_sdk" ]; };

  my-python-packages = python-packages: with python-packages; [
    pip
    bluepy
    bluepy-devices
    # cometblue-lite
    bsdiff4
    protobuf
    chardet
  ];
  # python-with-my-packages = unstable.python3.withPackages my-python-packages;
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
  ferdiumLatest = unstable.ferdium.overrideAttrs (oldAttrs: rec {
    #version = "6.1.1-nightly.17";
    version = "6.2.7";
    src = fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-amd64.deb";
      sha256 = "sha256-xsRHpfaI9IGmGxpTOh+IYWOIPYQibKcie23z2vzvWqY=";
    };
  });
  # androidComposition = unstable.androidenv.androidPkgs_9_0.androidsdk;


#  androidComposition = pkgs.androidenv.composeAndroidPackages {
#    includeEmulator = true;
#    emulatorVersion = "30.9.0";
#  };
   adoptopenjdk-hotspot-bin-15-low = pkgs.adoptopenjdk-hotspot-bin-15.overrideAttrs(oldAttrs: { meta.priority = 15; });
   adoptopenjdk-hotspot-bin-11-low = pkgs.adoptopenjdk-hotspot-bin-11.overrideAttrs(oldAttrs: { meta.priority = 30; });
   adoptopenjdk-hotspot-bin-8-low = pkgs.adoptopenjdk-hotspot-bin-8.overrideAttrs(oldAttrs: { meta.priority = 45; });

in

{
  programs.home-manager.enable = true;

  home.stateVersion = "21.05";
  home.username = "aj";
  home.homeDirectory = "/home/aj";

  home.packages = [ ferdiumLatest pkgs.paperwork pkgs.outils pkgs.grpc-tools pkgs.grpcurl pkgs.wine pkgs.winetricks pkgs.nix-bundle pkgs.nixpkgs-fmt pkgs.mycrypto pkgs.monero-gui pkgs.zlib pkgs.gmp pkgs.openssl pkgs.socat unstable.hugo pkgs.go-ethereum pkgs.openethereum pkgs.bisq-desktop pkgs.google-drive-ocamlfuse pkgs.onlyoffice-bin pkgs.mosh pkgs.openshot-qt pkgs.kdenlive pkgs.hunspell pkgs.hunspellDicts.en-us pkgs.hunspellDicts.de-de pkgs.usbtop pkgs.btop pkgs.rbenv pkgs.nodejs pkgs.kazam pkgs.qpdf pkgs._3proxy pkgs.nextcloud-client pkgs.spectral pkgs.yarn2nix pkgs.nodejs pkgs.git-filter-repo pkgs.swaks unstable.vscodium unstable.ffmpeg-full pkgs.siege pkgs.krusader pkgs.filezilla pkgs.gsettings-desktop-schemas pkgs.fluent-bit pkgs.sops pkgs.rclone pkgs.drill pkgs.du-dust pkgs.viu pkgs.gron pkgs.xsv pkgs.ansible pkgs.kalendar pkgs.drawio pkgs.akonadi pkgs.unetbootin pkgs.fluxctl pkgs.xsel pkgs.dos2unix pkgs.sshpass pkgs.ripgrep pkgs.byzanz pkgs.peek pkgs.docker-compose pkgs.sshuttle pkgs.android-tools unstable.dart pkgs.flutter pkgs.dialog pkgs.lens pkgs.x2goclient pkgs.python39Full python39Packages.pip python39Packages.virtualenv pkgs.rpl pkgs.azure-cli pkgs.azure-functions-core-tools pkgs.azure-storage-azcopy pkgs.pwgen pkgs.rpi-imager pkgs.go pkgs.gopls pkgs.golangci-lint pkgs.pdfgrep pkgs.mediathekview pkgs.ktorrent pkgs.filezilla pkgs.hugs pkgs.pavucontrol pkgs.pdsh pkgs.autojump unstable.jameica pkgs.freecad pkgs.sipcalc pkgs.glibc pkgs.kcalc pkgs.asdf-vm unstable.awscli2 pkgs.oathToolkit pkgs.aws-mfa pkgs.gsctl pkgs.git-crypt pkgs.zip pkgs.signal-desktop pkgs.ruby pkgs.gnome-network-displays pkgs.glibc unstable.evince pkgs.handbrake adoptopenjdk-hotspot-bin-8-low adoptopenjdk-hotspot-bin-11-low adoptopenjdk-hotspot-bin-15-low pkgs.postgresql_13 ]; # python-with-my-packages androidComposition
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
    PYTHONPATH = "${python-with-my-packages}/${python-with-my-packages.sitePackages}";
    # ANDROID_SDK_ROOT = "${androidComposition}/libexec/android-sdk";
    # ANDROID_NDK_ROOT = "\${ANDROID_SDK_ROOT}/ndk-bundle";
    JAVA_8_HOME = "${adoptopenjdk-hotspot-bin-8-low}";
    JAVA_11_HOME = "${adoptopenjdk-hotspot-bin-11-low}";
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
