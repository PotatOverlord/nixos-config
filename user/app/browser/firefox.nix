{ config, pkgs, ... }

{
  home.packages = [
    firefox
  ];

  programs.firefox.enable = true;
}
