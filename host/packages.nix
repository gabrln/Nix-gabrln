{ pkgs, ... }:

{
  # System Packages
  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
    nwg-look
    vesktop
    obsidian
    bazaar
    cage
    firefox
    opencode
    opencode-desktop
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
    ddcutil
    xdg-desktop-portal-gtk
    libqalculate
    btop
    
    # Basic compression/extraction utilities
    zip
    unzip
    p7zip
    unrar
    docker-compose
  ];

  # Session variables for Qt, Wayland (Electron), and Vulkan
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };
}
