{ ... }:

{
  # Unlimited physical memory locking for the audio group
  # Prevents audio buffers from being paged to disk
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
  ];

  # Audio (Pipewire with low latency tuning and click fix)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig = {
      # Fixed clocks and safe latency buffer (~5ms)
      pipewire."10-clock" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 1024;
        };
      };
      # Fix for stutters and audio glitches in emulated PulseAudio via Wine/Proton in games
      pipewire-pulse."10-stutters-fix" = {
        "pulse.properties" = {
          "pulse.default.req" = "256/48000";
          "pulse.min.req" = "256/48000";
          "pulse.min.frag" = "256/48000";
          "pulse.min.quantum" = "256/48000";
        };
      };
    };

    # Disable physical output suspension to remove activation pops
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
}
