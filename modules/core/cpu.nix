{ ... }:

{
  # Intel CPU microcode updates (security/stability)
  hardware.cpu.intel.updateMicrocode = true;

  # Fix Intel CPU throttling (BD PROCHOT)
  services.throttled.enable = true;
}