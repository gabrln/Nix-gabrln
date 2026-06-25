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

  # Audio (PipeWire via nix-gaming low-latency module)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # nix-gaming PipeWire low-latency module handles:
  # - quantum, rate, RT scheduling
  # - PulseAudio min.req/min.quantum/min.frag
  # - client stream latency and resample quality
  services.pipewire.lowLatency = {
    enable = true;
    quantum = 256;
    rate = 48000;
  };

  # Explicit PipeWire low-latency config (complements nix-gaming module)
  services.pipewire.extraConfig.pipewire = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 256;
      "default.clock.min-quantum" = 64;
      "default.clock.max-quantum" = 4096;
    };
  };
  services.pipewire.extraConfig.client = {
    "pipewire.default.quantum" = 256;
    "pipewire.default.rate" = 48000;
    "pipewire.min.req" = 128;
    "pipewire.min.quantum" = 64;
  };
}
