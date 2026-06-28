# Nix-gabrln

NixOS config: MangoWM + Noctalia + nvf.

## Repo map

```
~/.config/nixos/
├── flake.nix          -- inputs: nixpkgs, hm, mango, noctalia, chaotic, nix-gaming, nvf
├── vars.nix           -- user/host/locale/timezone
├── host/              -- boot, services, packages, hardware-config
├── modules/
│   ├── core/          -- base, latency, audio, gpu, cpu, ananicy, podman
│   └── home/          -- home.nix + programs/ + wayland/ + dotfiles/
```

## Vault

`~/Documents/obsidian/B05 Systems/` — docs do sistema.
`~/Documents/obsidian/C04 Agent/` — instruções do agente.

## Branches

- `experimental`: desenvolvimento ativo, kernel NixOS padrão
- `main`: espelho de experimental, estável/produção

## Rebuild

```bash
rebuild    # cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#gabrln
update     # nix flake update && rebuild
```

- **Requ rebuild**: mudanças em `.nix`, inputs
- **Sem rebuild**: dotfiles mutáveis (kitty, mango, zsh, yazi, zellij)

## Dotfiles vs Declarativo

| Tipo | Exemplo | Rebuild | Aplicação |
|------|---------|---------|-----------|
| Mutável (symlink) | `kitty.conf`, `mango.conf`, `.zshrc`, `yazi/`, `config.kdl` | Não | Imediato |
| Declarativo (nix) | `zsh.nix`, `nvim.nix` | Sim | Após rebuild |

## Dois Repositórios

- **Nix Config** → `git@github.com:gabrln/Nix-gabrln.git` (`experimental` → `main`)
- **Obsidian Vault** → `git@github.com:gabrln/obsidian-vault.git` (`main`)
- Commits separados em cada repo
- Mudanças no config → documentar no vault
