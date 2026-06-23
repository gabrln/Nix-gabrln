# NixOS Experimental - Dotfiles Diretos

Este repositório contém a configuração experimental do NixOS para o usuário `gabrln`, usando **MangoWM + Noctalia + Neovim** com temas dinâmicos.

## Instalação mínima do dotfile experimental

1. **Clone a branch `experimental`** em `~/.config/nixos`:
   ```bash
   git clone -b experimental https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos
   ```

2. **Copie o hardware real gerado pelo instalador**:
   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/default/hardware-configuration.nix
   ```

3. **Recompile e aplique o sistema**:
   ```bash
   cd ~/.config/nixos
   nixos-rebuild switch --flake .#gabrln
   ```

4. **Atualizar no futuro**:
   ```bash
   cd ~/.config/nixos
   git pull origin experimental
   nixos-rebuild switch --flake .#gabrln
   ```

## Estrutura atual

```text
~/.config/nixos
├── flake.nix
├── flake.lock
├── hosts/default/
│   └── hardware-configuration.nix
└── modules/
    ├── core/
    └── home/
```

## O que essa branch entrega

- `MangoWM` como gerenciador de janelas Wayland.
- `Noctalia` para shell, temas dinâmicos e runtime theming.
- `Neovim` com tema dinâmico via `matugen.lua`.
- Configuração modular separando `modules/core` e `modules/home`.

## Como usar

- Use `experimental` para desenvolvimento e testes.
- Para migrar para `main`:
  ```bash
  git checkout main
  git pull origin main
  nixos-rebuild switch --flake .#gabrln
  ```
