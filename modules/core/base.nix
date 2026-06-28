{ pkgs, vars, ... }:

{
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

    # Increase the download buffer size to avoid timeouts (512 MB)
    download-buffer-size = 536870912;
    max-jobs = "auto";
    cores = 0;
  };

  # Automatic garbage collection (weekly, keep last 10 generations)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  # 2. Networking & Locale
  networking.hostName = vars.hostName;
  networking.networkmanager.enable = true;
  time.timeZone = vars.timeZone;
  i18n.defaultLocale = vars.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.defaultLocale;
    LC_IDENTIFICATION = vars.defaultLocale;
    LC_MEASUREMENT = vars.defaultLocale;
    LC_MONETARY = vars.defaultLocale;
    LC_NAME = vars.defaultLocale;
    LC_NUMERIC = vars.defaultLocale;
    LC_PAPER = vars.defaultLocale;
    LC_TELEPHONE = vars.defaultLocale;
    LC_MESSAGES = "en_US.UTF-8";
    LC_TIME = vars.defaultLocale;
  };

  # Keyboard Layout (ABNT2) - handled by MangoWM env var XKB_DEFAULT_LAYOUT
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # 3. User Configuration (Gabriel)
  users.users.${vars.userName} = {
    isNormalUser = true;
    initialHashedPassword = "$6$1pFjnI70Pl2rHzgL$80/3xJ6nnvH/tdAQpfzP2oTwD39MvrxK10d/vHmYmLnJsW9nfNwjqmWDgLVH1CHStWlMp5tbs.8nM/vVQPrfL1";
    description = vars.userDescription;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "i2c" "docker" "gamemode" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Passwordless sudo rules for basic system commands
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

  # nix-ld: allows running dynamically linked binaries (Mason, treesitter parsers, etc.)
  programs.nix-ld.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # DNS-over-TLS via systemd-resolved
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        DNSOverTLS = "true";
        FallbackDNS = [ "1.1.1.1#cloudflare-dns.com" "8.8.8.8#dns.google" ];
      };
    };
  };

  # Fallback DNS (plaintext, used when resolved is unavailable)
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # NVMe I/O scheduler (none = no scheduler, direct to device)
  hardware.block.defaultScheduler = "none";

  # Automatic weekly system updates for security patches
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

}
