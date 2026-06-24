{ ... }:

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
      configurationLimit = 3;
    };
    loader.efi.canTouchEfiVariables = true;

    # Clean temporary files from the SSD on every boot
    tmp.cleanOnBoot = true;
  };

  # Desktop Program Enablements
  programs.mango.enable = true;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.xwayland.enable = true;
}
