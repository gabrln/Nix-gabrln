# Nix-gabrln

NixOS config with **MangoWM**, **Noctalia V5**.

## Branches

| Branch | Use Case |
|--------|----------|
| `experimental` | Desenvolvimento, kernel NixOS padrão, BORE scheduler |
| `main` | Espelho do `experimental` (estável/produção) |

```bash
# Instalação
git clone https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos
cd ~/.config/nixos
sudo nixos-rebuild switch --flake .
```

## Installation

> **No Git?** Use `nix-shell -p git` to get a temporary git without installing it system-wide.

```bash
# 1. Clone (HTTPS — no SSH key needed yet)
git clone https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos

# 2. Copy hardware config from the installer
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/host/hardware-configuration.nix

# 3. Build
cd ~/.config/nixos
nixos-rebuild switch --flake .#gabrln
```

### SSH Key (opcional, para push)

```bash
# Gerar chave SSH (se não existir)
ssh-keygen -t ed25519 -C "seu-email@github.com"

# Adicionar ao ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copiar chave pública
cat ~/.ssh/id_ed25519.pub

# Adicionar no GitHub > Settings > SSH and GPG keys > New SSH key

# Testar conexão
ssh -T git@github.com

# Trocar remote para SSH
cd ~/.config/nixos
git remote set-url origin git@github.com:gabrln/Nix-gabrln.git
```

## Stack

| Layer | Tool |
|--------|-----------|
| Kernel | Standard NixOS (BORE) |
| Compositor | MangoWM |
| Shell | Noctalia V5 |
| Audio | PipeWire (explicit low-latency config) |
| Gaming | Gamemode, MangoHud, Steam + Gamescope |
| Terminal | Kitty |
| Editor | Neovim (nvf) |
| File Manager | Yazi + Nautilus |
| Multiplexer | Zellij |
| Prompt | Starship (Noctalia themed) |
