# /system/security/mullvad.nix
{
  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ]
  services.mullvad-vpn.enable = true;
}
