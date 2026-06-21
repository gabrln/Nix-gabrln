{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./packages.nix
    ./intel-gpu.nix
    ./podman.nix
  ];

  # 1. Nix Settings & Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ 
      "https://noctalia.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [ 
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    auto-optimise-store = true;
    # Aumenta o tamanho do buffer de download para evitar timeouts (512 MB)
    download-buffer-size = 536870912;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # 2. Bootloader e Configurações de Latência do Kernel
  boot = {
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    loader.efi.canTouchEfiVariables = true;

    # Limpa arquivos temporários no SSD a cada inicialização
    tmp.cleanOnBoot = true;

    # Ajustes de baixa latência e prioridade para RAM/Kernel
    kernel.sysctl = {
      # swappiness de 100 força a compactação no ZRAM em vez de ejetar o cache de páginas do FS
      "vm.swappiness" = 100;
      # Desativa watermark boost para mitigar stutters de I/O em picos de alocação de memória
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      # Evita pré-alocação agressiva de swap (otimização ZRAM)
      "vm.page-cluster" = 0;
    };
  };

  # Ativa swap compactada na RAM (ZRAM)
  zramSwap.enable = true;

  # Regras Administrativas de Sudo sem Senha (NOPASSWD) para comandos básicos
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          { command = "/run/current-system/sw/bin/shutdown"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/reboot"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/poweroff"; options = [ "NOPASSWD" ]; }
          { command = "/run/wrappers/bin/mount"; options = [ "NOPASSWD" ]; }
          { command = "/run/wrappers/bin/umount"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };

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

  # Enable dconf for GTK themes (nwg-look / gsettings)
  programs.dconf.enable = true;

  # Enable Steam with 32-bit hardware support & firewall rules
  programs.steam.enable = true;

  # Enable XWayland support
  programs.xwayland.enable = true;

  # System state version
  system.stateVersion = "24.05";
}
