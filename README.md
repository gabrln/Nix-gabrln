# NixOS Experimental - Dotfiles Diretos

Este repositório contém a configuração experimental do NixOS para o usuário `gabrln`, usando **MangoWM + Noctalia + Neovim** com temas dinâmicos.

## Instalação mínima do dotfile experimental

1. **Clone a branch `experimental`** em `~/.config/nixos`:
   ```bash
   nix-shell -p git --run 'git clone -b experimental https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos'
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

## O que essa branch entrega

- `MangoWM` como gerenciador de janelas Wayland.
- `Noctalia` para shell e temas dinâmicos.
- `Neovim` com tema dinâmico carregado via `matugen.lua`.
- Configuração modular em `home/gabrln` e `hosts/default`.

## Estrutura essencial

```text
~/.config/nixos
├── flake.nix
├── flake.lock
├── hosts/default/
│   └── hardware-configuration.nix
└── home/gabrln/
    ├── home.nix
    └── wayland/noctalia.nix
```

## Nota rápida

- Use `experimental` para desenvolvimento e testes.
- Se quiser ir para `main`, basta:
  ```bash
  git checkout main && nixos-rebuild switch --flake .#gabrln
  ```

Isso é o suficiente para instalar e manter o dotfile experimental de forma direta e enxuta.
