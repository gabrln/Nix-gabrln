{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./services.nix
    ./packages.nix
  ];

  # Desktop Program Enablements
  # Enable MangoWM compositor system module
  programs.mango.enable = true;

  # Enable dconf for GTK themes (nwg-look / gsettings)
  programs.dconf.enable = true;

  # Enable Steam with 32-bit hardware support & firewall rules
  programs.steam.enable = true;

  # Enable XWayland support
  programs.xwayland.enable = true;

  # System state version
  system.stateVersion = "26.05";
}
