# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, systemSettings, userSettings, ... }:
{
  imports =
    [ ./hardware-configuration.nix
      ../../system/hardware/systemd.nix # systemd config
      ../../system/hardware/power.nix # Power management
      ../../system/hardware/time.nix # Network time sync
      ../../system/security/doas.nix
      ../../system/hardware/opengl.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/bluetooth.nix
      ../../system/wm/hyprland.nix
      #../../system/app/flatpak.nix
      #../../system/app/virtualization.nix
      #( import ../../system/app/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
      ../../system/security/gpg.nix
      ../../system/security/firewall.nix
      ../../system/security/openvpn.nix
      ../../system/security/mullvad.nix
      ../../system/security/automount.nix
      ../../system/style/stylix.nix
      ../../system/app/gamemode.nix
      #../../system/app/steam.nix
      ../../system/app/prismlauncher.nix
      #../../user/app/nvim/nvim.nix 
      ( import ../../system/security/sshd.nix {
            authorizedKeys = [ "" ];
            inherit userSettings; })
    ];

  # Fix nix path
  #nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  #                "nixos-config=$HOME/dotfiles/system/configuration.nix"
  #                "/nix/var/nix/profiles/per-user/root/channels"
  #              ];

  # Ensure nix flakes are enabled
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  programs.darling.enable = false;

  # wheel group gets trusted access to nix daemon
  nix.settings.trusted-users = [ "@wheel" ];

  # Kernel modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];

  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios

  # Networking
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager

  # Timezone and locale
  time.timeZone = systemSettings.timezone; # time zone
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = "tater";
    extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" "render" ];
    packages = [];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    git
    cryptsetup
    home-manager
    wpa_supplicant
    (pkgs.writeScriptBin "comma" ''
      if [ "$#" = 0 ]; then
        echo "usage: comma PKGNAME... [EXECUTABLE]";
      elif [ "$#" = 1 ]; then
        nix-shell -p $1 --run $1;
      elif [ "$#" = 2 ]; then
        nix-shell -p $1 --run $2;
      else
        echo "error: too many arguments";
        echo "usage: comma PKGNAME... [EXECUTABLE]";
      fi
    '')
  ];

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fonts.fontDir.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # It is ok to leave this unchanged for compatibility purposes
  system.stateVersion = "24.11";

}
