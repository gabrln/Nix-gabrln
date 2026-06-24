# Nix-gabrln

NixOS config with **MangoWM**, **Noctalia**, and dynamic theming.

## Installation

> **Sem Git?** Use `nix-shell -p git` para ter acesso temporário ao git sem instalar nada no sistema.

```bash
# 1. Clonar
git clone -b experimental https://github.com/gabrln/Nix-gabrln.git /home/.config/nixos

# 2. Copiar hardware do instalador
cp /etc/nixos/hardware-configuration.nix /home/.config/nixos/host/hardware-configuration.nix

# 3. Build
cd /home/.config/nixos
nixos-rebuild switch --flake .#gabrln
```

### Atualizar

```bash
cd /home/.config/nixos
git pull origin experimental
nixos-rebuild switch --flake .#gabrln
```

> O repositório é clonado em `/home/.config/nixos` (fora do home do usuário) — certifique-se de que o path existe e tem permissões corretas.

## Estrutura

```
.
├── flake.nix              # inputs, outputs, módulos do sistema
├── vars.nix               # usuário, hostname, locale
├── host/                  # config da máquina
│   ├── default.nix        # boot, compositor, XWayland
│   ├── packages.nix       # pacotes do sistema
│   ├── services.nix       # earlyoom, flatpak, greetd, portal
│   └── hardware-configuration.nix  # gerado pelo instalador
└── modules/
    ├── core/              # módulos de sistema
    │   ├── base.nix       # nix settings, rede, usuário, sudo
    │   ├── audio.nix      # PipeWire tuning
    │   ├── latency.nix    # ZRAM, swappiness, kernel params
    │   ├── gpu.nix        # Intel i915, VAAPI
    │   └── docker.nix     # Docker daemon
    └── home/              # home-manager
        ├── home.nix       # identidade, GTK, Qt, MIME, xdg
        ├── wayland/
        │   ├── mango.nix  # MangoWM keybinds + scripts
        │   └── noctalia.nix  # Noctalia shell + templates
        ├── programs/
        │   ├── kitty.nix
        │   ├── zsh.nix
        │   ├── yazi.nix
        │   ├── zellij.nix
        │   ├── nvim.nix
        │   └── git.nix
        ├── webapps.nix    # web apps como desktop entries
        └── dotfiles/      # configs mutáveis (symlinks fora da store)
```

## Stack

| Camada | Ferramenta |
|--------|-----------|
| Compositor | MangoWM |
| Shell/DE | Noctalia V5 |
| Terminal | Kitty |
| Editor | Neovim (nixvim) |
| File Manager | Yazi |
| Multiplexer | Zellij |
| Prompt | Starship |
| Theme | Noctalia (Catppuccin builtin) |
| GTK | adw-gtk3-dark + Papirus-Dark |
