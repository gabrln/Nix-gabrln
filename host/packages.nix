{ pkgs, inputs, ... }:

{
  # System Packages
  environment.systemPackages = with pkgs; [
    # MangoWM compositor with 10-tag support
    (inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace src/config/preset.h \
          --replace '"1", "2", "3", "4", "5", "6", "7", "8", "9",' '"1", "2", "3", "4", "5", "6", "7", "8", "9", "10",'
      '';
    }))
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
    mcp-nixos
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

    # Gaming
    mangohud
  ];

  # Steam expansions
  programs.steam = {
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # nix-gaming Steam platform optimizations
  programs.steam.platformOptimizations.enable = true;

  # Session variables for Qt, Wayland (Electron), and Vulkan
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };
}
