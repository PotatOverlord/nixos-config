# /system/security/mullvad.nix
{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ];
  services.mullvad-vpn.enable = true;
}
