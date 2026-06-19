{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./packages.nix
  ];

  # 1. Nix Settings & Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # 2. Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 3. Networking & Locale
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" ];
  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = "8.8.8.8";
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # 4. Keyboard Layout (ABNT2)
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # 5. User Configuration (Gabriel)
  users.users.gsouza = {
    isNormalUser = true;
    description = "Gabriel de Souza";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Enable MangoWM system module
  programs.mango.enable = true;

  # Enable XWayland support
  programs.xwayland.enable = true;

  # System state version
  system.stateVersion = "24.05";
}
