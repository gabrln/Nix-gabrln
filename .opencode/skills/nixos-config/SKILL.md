---
name: nixos-config
description: Use when the user mentions NixOS, nvf, Neovim, rebuild, flake, podman, kernel, audio, GPU, gaming, DNS, firewall, or any system component. Provides repo structure, module map, and INDEX reference.
---

# NixOS Configuration Reference

## Repo structure

```
~/.config/nixos/
├── flake.nix          → nixpkgs, hm, mango, noctalia, chaotic, nix-gaming, nvf
├── host/
│   ├── boot.nix       → grub, kernel, gamemode, steam
│   ├── services.nix   → earlyoom, ssh, flatpak, greetd, portais
│   └── packages.nix   → system packages, steam, session vars
├── modules/core/
│   ├── base.nix       → nix settings, user, firewall, dns, autoUpgrade
│   ├── latency.nix    → sysctl, zram, i2c, kernel hardening
│   ├── audio.nix      → pipewire low-latency (extraConfig)
│   ├── gpu.nix        → intel i915, vaapi
│   ├── cpu.nix        → microcode, throttled
│   ├── ananicy.nix    → ananicy-cpp
│   └── podman.nix     → podman rootless + dockerCompat
└── modules/home/
    ├── home.nix       → identity, gtk, mime, activation
    ├── programs/      → kitty, zsh, yazi, zellij, nvim, git, webapps
    ├── wayland/       → mango, noctalia
    └── dotfiles/      → symlinks: kitty, mango, yazi, zellij, zsh, opencode

Cada .nix tem doc em ~/Documents/obsidian/B05 Systems/Configs/
```

## Vault INDEX

Full mapping at [[System Index]] (~/Documents/obsidian/C04 Agent/Reference/System Index.md).

Key paths:
- NixOS docs: `~/Documents/obsidian/B05 Systems/NixOS/`
- Agent docs: `~/Documents/obsidian/C04 Agent/`
