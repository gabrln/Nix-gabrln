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
}
