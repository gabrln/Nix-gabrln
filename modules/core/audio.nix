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

  # Audio (PipeWire low-latency via explicit config)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Explicit PipeWire low-latency config
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
