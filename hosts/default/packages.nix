{ config, pkgs, inputs, ... }:

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
    (inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace src/config/preset.h \
          --replace '"1", "2", "3", "4", "5", "6", "7", "8", "9",' '"1", "2", "3", "4", "5", "6", "7", "8", "9", "10",'
      '';
    })) # MangoWM/mangowc compositor
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide-no-fhs
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
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
