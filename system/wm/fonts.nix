{ pkgs-stable, ...}:

{
  fonts.packages = with pkgs; [
    nerdfonts
    powerline
  ];
}
