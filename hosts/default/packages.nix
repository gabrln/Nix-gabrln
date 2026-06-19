{ config, pkgs, inputs, ... }:

{
  # System Packages
  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    cage
    firefox
    inputs.mango.packages.${pkgs.system}.default # MangoWM/mangowc compositor
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-ide-no-fhs
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    cliphist
    wl-clipboard
    libnotify
    papirus-icon-theme
    bibata-cursors
    
    # Noctalia and theme dependencies
    brightnessctl
    grim
    slurp
    adw-gtk3
    kdePackages.qt6ct
    xdg-desktop-portal-gtk
    libqalculate
    btop
    
    # Basic compression/extraction utilities
    zip
    unzip
    p7zip
    unrar
  ];

  # Session variables for Qt themes
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
