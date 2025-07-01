{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dotnetCorePackages.sdk_9_0_1xx-bin
  ];

}
