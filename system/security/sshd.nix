{ userSettings, authorizedKeys ? [], ... }:

{
  # Enable incoming ssh
  services.openssh = {
    openFirewall = true;
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  users.users.${userSettings.username}.openssh.authorizedKeys.keys = authorizedKeys;
}
