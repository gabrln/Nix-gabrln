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
    
    # Dependências do Noctalia e temas
    brightnessctl
    grim
    slurp
    adw-gtk3
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    xdg-desktop-portal-gtk
    libqalculate
    btop
    
    # Ferramentas básicas de compressão/extração
    zip
    unzip
    p7zip
    unrar
  ];

  # Variáveis de sessão para temas Qt
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
