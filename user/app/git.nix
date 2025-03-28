{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  programs.git.userName = "PotatOverlord";
  programs.git.userEmail = "160378192+PotatOverlord@users.noreply.github.com";
}
