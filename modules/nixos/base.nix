{ config, pkgs, inputs, vars, ... }:

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
    auto-optimise-store = true;
    # Increase the download buffer size to avoid timeouts (512 MB)
    download-buffer-size = 536870912;
  };

  # Automatic garbage collection (disabled to avoid conflict with nh.clean)
  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # 2. Networking & Locale
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
    LC_TIME = vars.defaultLocale;
  };

  # Keyboard Layout (ABNT2)
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # 3. User Configuration (Gabriel)
  users.users.${vars.userName} = {
    isNormalUser = true;
    description = vars.userDescription;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "i2c" "docker" ];
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

  # Enable nh (Nix Helper) for cleaner and faster rebuilds
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10";
    flake = "/home/${vars.userName}/.config/nixos";
  };
}
