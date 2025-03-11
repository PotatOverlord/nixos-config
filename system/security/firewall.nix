{ ... }:

{
  networking.firewall = { 
  enable = true;
  allowedTCPPorts = [ 22000 21027 ]; #syncthing
  allowedUDPPorts = [ 22000 21027 ];
  };
}
