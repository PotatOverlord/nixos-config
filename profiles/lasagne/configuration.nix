{ userSettings, systemSettings, ... }:

{
  imports = [ ./base.nix
              ( import ../../system/security/sshd.nix {
                authorizedKeys = [ 
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK4fRchvTJr3nI9pM4t22Uv7K2pGkSglMViZHkVvUBN tater@cheese"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMz53GW4JtHbPLshCcUO2XFTOpG8Tw1noN4sj99TVV8Z tater@fish"
                ];
                inherit userSettings; })
            ];
}
