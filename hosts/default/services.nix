{ config, pkgs, inputs, ... }:

{
  # Audio (Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Hardware & Services required by Noctalia / Wayland
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Noctalia Greeter configuration via NixOS module
  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.system}.default;
    settings.cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  # Forçar escala do login manager (Noctalia Greeter) para 1.0
  system.activationScripts.noctalia-greeter-scale = {
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

  # Greetd Login Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  # Desbloqueio automático do GNOME Keyring no login via greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  # XDG Portals (necessário para launcher do Noctalia)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
