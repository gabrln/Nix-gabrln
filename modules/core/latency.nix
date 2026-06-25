{ ... }:

{
  # 1. Low latency and priority adjustments for RAM/Kernel
  boot.kernel.sysctl = {
    # Swappiness of 100 forces compression in ZRAM instead of ejecting page cache from the FS
    "vm.swappiness" = 100;
    # Disable watermark boost to mitigate I/O stutters during memory allocation peaks
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # Prevent aggressive swap pre-allocation (ZRAM optimization)
    "vm.page-cluster" = 0;
  };

  # Load the i2c-dev driver to allow brightness control via ddcutil
  boot.kernelModules = [ "i2c-dev" ];

  # Enable compressed swap in RAM via systemd-zram-generator (zstd compression)
  services.zram-generator.enable = true;
  services.zram-generator.settings = {
    zram0 = {
      "zram-size" = "ram / 2";
      "compression-algorithm" = "zstd";
      "fs-type" = "swap";
    };
  };

  # Enable the I2C bus for monitor hardware control
  hardware.i2c.enable = true;
}
