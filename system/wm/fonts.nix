{ pkgs-stable, ...}:

{
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    powerline
  ];
}
