{ config, lib, inputs, vars, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  # Preservation of essential system-level data
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
      "/var/lib/containers" # Persists Podman and Docker images/data
    ];
    files = [
      "/etc/machine-id"
      "/etc/shadow"
      "/etc/passwd"
      "/etc/group"
      "/etc/subuid"
      "/etc/subgid"
    ];
  };

  # Bind mount persistent user home directories
  environment.persistence."/persist".users.${vars.userName} = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Projects" # Your projects and code
      ".config/nixos" # The repository itself to allow running nh os switch
      ".local/share/Steam"
      ".steam"
      ".mozilla"
    ];
  };
}
