{ userSettings, ... }:

{
  imports = [ ./disko.nix
              ./base.nix
              ( import ../../system/security/sshd.nix {
                authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK4fRchvTJr3nI9pM4t22Uv7K2pGkSglMViZHkVvUBN tater@cheese"];
                inherit userSettings; })
            ];
}
