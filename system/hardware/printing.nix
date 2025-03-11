{ pks, ... }:

{
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  enviroment.systemPackages = [ pks.cups-filters ];
}
