{ config, pkgs, ... }:

{
  # Force loading of the i915 driver in stage 1 boot to prevent screen flickering in MangoWM/Wayland
  boot.initrd.kernelModules = [ "i915" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Steam, Wine, and Proton to run 32-bit games
    extraPackages = with pkgs; [
      intel-media-driver   # iHD driver (modern media decoding for Gen 12)
      libva-vdpau-driver
      libvdpau-va-gl       # VDPAU to VAAPI compatibility bridge
      vpl-gpu-rt           # OneVPL GPU runtime for processing on Gen 12+
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
    ];
  };
}
