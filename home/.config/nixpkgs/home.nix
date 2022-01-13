{ config, pkgs, libs, ... }:

with pkgs;
let
  unstable = import <nixos-unstable> {};
  my-python-packages = python-packages: with python-packages; [
    pip
    bluepy
    bluepy-devices
    cometblue-lite
  ];
  python-with-my-packages = unstable.python39.withPackages my-python-packages;
  ferdiLatest = pkgs.ferdi.overrideAttrs (oldAttrs: rec {
    version = "5.7.0";
    src = fetchurl {
      url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
      sha256 = "sha256-WwtnYNjXHk80o1wMsEBoaT9j0+4TWTfWhuVpGHaZB7c=";
    };
  });
in

{
  programs.home-manager.enable = true;

  home.stateVersion = "21.05";
  home.username = "aj";
  home.homeDirectory = "/home/aj";

  home.packages = [ ferdiLatest pkgs.openjdk11 pkgs.hugs pkgs.pavucontrol pkgs.pdsh pkgs.autojump pkgs.jameica pkgs.freecad pkgs.sipcalc pkgs.glibc pkgs.kcalc pkgs.asdf-vm pkgs.awscli2 pkgs.oathToolkit pkgs.aws-mfa pkgs.gsctl pkgs.aws-iam-authenticator pkgs.git-crypt pkgs.zip pkgs.signal-desktop pkgs.ruby pkgs.torbrowser pkgs.gnome-network-displays pkgs.glibc python-with-my-packages unstable.evince ];
  # nix-env -f .nix-defexpr/channels/nixos-unstable -iA signal-desktop 

  programs.git = {
    enable = true;
    userName = "derjohn";
    userEmail = "himself@derjohn.de";
    aliases = {
      st = "status";
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.bashrc.extra
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.nix-direnv.enableFlakes = true;
  programs.zsh.enable = true;
  programs.autojump.enable = true ;

  home.sessionVariables = {
    PYTHONPATH = "${python-with-my-packages}/${python-with-my-packages.sitePackages}";
  };

  programs.vim = {
    enable = true;
    # extraConfig = builtins.readFile vim/vimrc.vim;
    extraConfig = ''
      set mouse=v
    '';
    settings = { number = true; };
    plugins = [ # Defined here: pkgs/misc/vim-plugins/default.nix
      # Standard plugins
      "nerdtree"
      "vim-airline"
      # New plugins
      "vim-better-whitespace"
    ];
  };

}
