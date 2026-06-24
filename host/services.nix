{ pkgs, inputs, ... }:

{
  # EarlyOOM Daemon to mitigate sudden freezes due to high RAM usage
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # Run SIGKILL if free RAM drops below 5%
    enableNotifications = true;
  };

  # Limit Journald log size to prevent unnecessary writes on SSD
  services.journald.extraConfig = ''
    SystemMaxUse=50M
  '';

  # Automatic SSD TRIM
  services.fstrim.enable = true;

  # Systemd limits and timeouts to avoid slow shutdowns (max 10s)
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "15s";
    DefaultTimeoutStopSec = "10s";
  };

  # Hardware & Services required by Noctalia / Wayland
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable Flatpak support for Bazaar and other installers
  services.flatpak.enable = true;

  # Add Flathub repository and configure theme permissions for Flatpak
  systemd.services.configure-flathub = {
    description = "Configurar repositório Flathub e overrides de tema para o Flatpak";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "flatpak-setup" ''
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        ${pkgs.flatpak}/bin/flatpak override --system --filesystem=/nix/store:ro
        ${pkgs.flatpak}/bin/flatpak override --system --filesystem=xdg-config/gtk-3.0:ro
        ${pkgs.flatpak}/bin/flatpak override --system --filesystem=xdg-config/gtk-4.0:ro
        ${pkgs.flatpak}/bin/flatpak override --system --filesystem=~/.themes:ro
        ${pkgs.flatpak}/bin/flatpak override --system --filesystem=~/.icons:ro
      '';
      RemainAfterExit = true;
    };
  };

  # Noctalia Greeter
  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings.cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  # Force login manager (Noctalia Greeter) scale to 1.0
  system.activationScripts.noctalia-greeter-scale = {
    deps = [ "users" ];
    text = ''
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/noctalia-greeter
      ${pkgs.coreutils}/bin/chown greeter:greeter /var/lib/noctalia-greeter
      ${pkgs.coreutils}/bin/chmod 0755 /var/lib/noctalia-greeter
      
      conf_file="/var/lib/noctalia-greeter/greeter.conf"
      if [ -f "$conf_file" ]; then
        if ${pkgs.gnugrep}/bin/grep -q "^scale=" "$conf_file"; then
          ${pkgs.gnused}/bin/sed -i 's/^scale=.*/scale=1.0/' "$conf_file"
        else
          echo "scale=1.0" >> "$conf_file"
        fi
      else
        echo "scale=1.0" > "$conf_file"
      fi
      ${pkgs.coreutils}/bin/chown greeter:greeter "$conf_file"
      ${pkgs.coreutils}/bin/chmod 0644 "$conf_file"
    '';
  };

  # Greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  # Auto-unlock GNOME Keyring at login via greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      mango = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };
}
