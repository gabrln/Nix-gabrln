{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./packages.nix
  ];

  # 1. Bootloader Settings
  # Configured for EFI with GRUB bootloader
  boot = {
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 3;
    };
    loader.efi.canTouchEfiVariables = true;

    # Clean temporary files from the SSD on every boot
    tmp.cleanOnBoot = true;
  };

  # 2. Desktop Program Enablements
  # Enable MangoWM compositor system module
  programs.mango.enable = true;

  # Enable dconf for GTK themes (nwg-look / gsettings)
  programs.dconf.enable = true;

  # Enable Steam with 32-bit hardware support & firewall rules
  programs.steam.enable = true;

  # Enable XWayland support
  programs.xwayland.enable = true;

  # System state version
  system.stateVersion = "24.05";
}
