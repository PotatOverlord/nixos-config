{ pkgs, ... }:
let
  durdraw = import ./durdraw.nix { inherit pkgs; };
in {
  # Collection of useful CLI apps
  home.packages = with pkgs; [
    durdraw
    # Command Line
    neofetch hyfetch lolcat cowsay
    starfetch
    ani-cli
    btop
    cava
    killall
    libnotify
    timer
    brightnessctl
    gnugrep
    eza 
    rsync
    unzip
    p7zip
    hwinfo
    numbat
    krabby
    (pkgs.writeShellScriptBin "airplane-mode" ''
      #!/bin/sh
      connectivity="$(nmcli n connectivity)"
      if [ "$connectivity" == "full" ]
      then
          nmcli n off
      else
          nmcli n on
      fi
    '')
    vim neovim
  ];
}
