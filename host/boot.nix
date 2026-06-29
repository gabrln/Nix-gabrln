{ pkgs, ... }:

{
  # System state version
  system.stateVersion = "26.05";

  # Bootloader Settings
  # Configured for EFI with GRUB bootloader
  boot = {
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;
    };
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 60;

    # Clean temporary files from the SSD on every boot
    tmp.cleanOnBoot = true;

    # Standard NixOS kernel (binary from cache.nixos.org)
    # Gaming kernel available via nix-gaming input if needed
    kernelPackages = pkgs.linuxPackages;
  };

  # Desktop Program Enablements
  programs.mango.enable = true;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.xwayland.enable = true;

  # GameMode - on-demand CPU/gaming optimizations
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general = {
      desiredgov = "performance";
      softrealtime = "auto";
    };
  };
}
