{ config, pkgs, inputs, ... }:

{
  # Bloqueio de memória RAM física ilimitada para o grupo de áudio
  # Evita que buffers de áudio sofram paginação para o disco
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
  ];

  # Audio (Pipewire com customização de baixa latência e correção de estalos)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig = {
      # Clocks fixos e buffer seguro de latência (~5ms)
      pipewire."10-clock" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 1024;
        };
      };
      # Correção de stutters e engasgos de áudio Pulse emulado via Wine/Proton em jogos
      pipewire-pulse."10-stutters-fix" = {
        "pulse.properties" = {
          "pulse.default.req" = "256/48000";
          "pulse.min.req" = "256/48000";
          "pulse.min.frag" = "256/48000";
          "pulse.min.quantum" = "256/48000";
        };
      };
    };

    # Desativa suspensão das saídas físicas para remover estalos (pops) de ativação
    wireplumber.extraConfig."51-disable-suspension" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.*"; } ];
          actions.update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        }
      ];
      "monitor.bluez.rules" = [
        {
          matches = [
            { "node.name" = "~bluez_input.*"; }
            { "node.name" = "~bluez_output.*"; }
          ];
          actions.update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        }
      ];
    };
  };

  # EarlyOOM Daemon para mitigar travamentos repentinos por consumo alto de RAM
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # Executa SIGKILL se RAM livre cair abaixo de 5%
    enableNotifications = true;
  };

  # Limitação de logs do Journald para evitar desgaste de escrita desnecessária no SSD
  services.journald.extraConfig = ''
    SystemMaxUse=50M
  '';

  # SSD TRIM automático
  services.fstrim.enable = true;

  # Limites e Timeouts do Systemd para evitar desligamentos lentos (máximo 10s)
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "15s";
    DefaultTimeoutStopSec = "10s";
  };

  # Hardware & Services requeridos pelo Noctalia / Wayland
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Habilita suporte a Flatpak para o Bazaar e outros instaladores
  services.flatpak.enable = true;

  # Adiciona repositório Flathub se ele já não existir
  systemd.services.configure-flathub = {
    description = "Configurar repositório Flathub para o Flatpak";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
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

  # Auto-unlock GNOME Keyring no login via greetd
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
