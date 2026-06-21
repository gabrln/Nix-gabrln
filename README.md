# Configuração Declarativa NixOS (MangoWM + Noctalia)

Este repositório contém a configuração declarativa do sistema operacional NixOS para o usuário gsouza, estruturada utilizando Nix Flakes e Home Manager. A interface gráfica é composta pelo compositor MangoWM e pela suite Noctalia Shell.

## Estrutura do Repositório

```text
nixos-config/
├── flake.nix                       # Ponto de entrada do Nix Flake com canais (26.05) e inputs
├── flake.lock                      # Travamento de versões exatas de dependências externas
├── README.md                       # Guia técnico de instalação e arquitetura
├── hosts/
│   └── default/                    # Configurações a nível de sistema (Root/System)
│       ├── default.nix             # Entrada do host (ZRAM, Kernel sysctl, GC, Sudo, Locales)
│       ├── hardware-configuration.nix # Mapeamento de hardware gerado pelo instalador do NixOS
│       ├── services.nix            # Pipewire, greetd, earlyoom, pam limits, bluetooth
│       ├── packages.nix            # Pacotes de sistema globais
│       ├── intel-gpu.nix           # Drivers e aceleração de vídeo Intel Iris Xe
│       └── podman.nix              # Virtualização de contêineres compatível com Docker
└── home/
    └── gsouza/                     # Configurações a nível de usuário (Home Manager)
        ├── home.nix                # Entrada do Home Manager (Temas, MIME Apps, ativações)
        ├── programs/               # Módulos de programas de terminal e editores
        │   ├── default.nix         # Importações do diretório de programas
        │   ├── kitty.nix           # Emulador de terminal Kitty
        │   ├── zsh.nix             # Configuração do Zsh, aliases e FZF
        │   ├── yazi.nix            # Gerenciador de arquivos de terminal Yazi
        │   ├── nvim.nix            # Configuração do Neovim (Nixvim sem autocompletar popups)
        │   └── zellij.nix          # Multiplexador de terminal Zellij
        └── wayland/                # Módulos do servidor gráfico
            ├── default.nix         # Importações de Wayland
            ├── mango.nix           # Configuração de atalhos e regras do MangoWM
            └── noctalia.nix        # Integração do shell e painéis do Noctalia
```

## Requisitos de Hardware e Otimizações

A configuração está otimizada para o processador Intel com placa integrada Iris Xe Graphics e 16GB de memória RAM:
1. **Vídeo (Intel Iris Xe):** Carregamento precoce do driver de kernel `i915` no initrd para evitar cintilação da tela. Utilização do driver `intel-media-driver` (iHD) para decodificação em hardware e definição de variáveis do Vulkan (`VK_ICD_FILENAMES`).
2. **Memória e ZRAM:** Compactação agressiva via ZRAM habilitada como swap principal. Parâmetros de kernel `vm.swappiness = 100`, `vm.watermark_boost_factor = 0` e `vm.page-cluster = 0` para evitar gargalos de escrita e leitura em SSD.
3. **Áudio de Baixa Latência (Pro-Audio):** Limites de RAM (`memlock`) configurados como ilimitados para o grupo `audio`. Pipewire configurado com relógio de 48kHz e tamanho de bloco (quantum) estável de 256 amostras (latência de ~5.3ms). Wireplumber com suspensão automática de ALSA e Bluetooth desativada.
4. **Virtualização:** Podman habilitado com socket de emulação do Docker para compatibilidade transparente com Devcontainers e ferramentas Docker originais.

## Guia de Instalação e Implantação

Você pode implantar esta configuração tanto em uma máquina nova utilizando o instalador gráfico (Calamares) quanto manualmente via linha de comando.

### Esquema de Particionamento e Subvolumes Btrfs Recomendado

Para tirar o máximo proveito das otimizações de disco (como compactação ativa e noatime) descritas nesta configuração, recomendamos estruturar o disco principal utilizando **Btrfs** com um layout plano de subvolumes:

| Subvolume | Ponto de Montagem | Opções de Montagem Recomendadas | Função |
| :--- | :--- | :--- | :--- |
| `/dev/sdX1` | `/boot` | `fmask=0077,dmask=0077` (FAT32) | Partição EFI de Boot |
| `@root` (ou `@`) | `/` | `subvol=root,compress=zstd,noatime,ssd` | Raiz do Sistema (OS) |
| `@home` | `/home` | `subvol=home,compress=zstd,noatime,ssd` | Arquivos pessoais do usuário |
| `@nix` | `/nix` | `subvol=nix,compress=zstd,noatime,ssd` | Repositório Nix Store (Read-Only/Store) |

> [!TIP]
> * **No Instalador Gráfico (Calamares):** Escolha o particionamento manual. Crie a partição EFI em FAT32 `/boot`. Em seguida, crie a partição Btrfs e configure os subvolumes montando `@` em `/`, `@home` em `/home` e `@nix` em `/nix`. O instalador gráfico aplicará as opções de montagem e gerará o arquivo `/etc/nixos/hardware-configuration.nix` correspondente de forma totalmente automática.

---

### Opção A: Pós-Instalação Gráfica (Recomendado)

Se você preferir instalar o NixOS usando a interface visual (Calamares) da imagem ISO oficial:

1.  **Instalação Base:** Realize a instalação do NixOS normalmente usando o instalador gráfico da ISO (definindo locales, fuso horário e particionamento padrão).
2.  **Primeira Inicialização:** Inicialize o novo sistema e abra o terminal.
3.  **Clonar Configurações:** Obtenha temporariamente o Git via Nix shell para clonar a ramificação `experimental` na sua pasta de usuário:
    ```bash
    nix-shell -p git
    git clone -b experimental https://github.com/gsouza/nixos-config.git ~/.config/nixos
    ```
4.  **Copiar Arquivo de Hardware:** Copie o arquivo de hardware gerado automaticamente durante a instalação para a pasta do repositório:
    ```bash
    cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/default/hardware-configuration.nix
    ```
5.  **Reconstruir o Sistema:** Aplique as configurações declarativas do flake executando:
    ```bash
    cd ~/.config/nixos
    nixos-rebuild switch --flake .#nixos
    ```
6.  **Pronto:** Após a reinicialização, o sistema carregará o MangoWM e o Noctalia, e você poderá usar o utilitário `nh os switch` normalmente para futuras atualizações.

---

### Opção B: Instalação Manual via CLI

Para fazer a instalação limpa diretamente a partir da linha de comando no terminal da ISO:

#### 1. Preparação e Particionamento (Btrfs)
Execute o particionamento utilizando `gdisk` ou `parted` (esquema GPT):
*   `/dev/sdX1`: Partição de Boot (FAT32/vfat, mínimo 512MB).
*   `/dev/sdX2`: Partição Root (Btrfs).

Crie e monte os subvolumes Btrfs:
```bash
mount /dev/sdX2 /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
umount /mnt

mount -o subvol=root,compress=zstd,noatime /dev/sdX2 /mnt
mkdir -p /mnt/boot /mnt/home /mnt/nix
mount /dev/sdX1 /mnt/boot
mount -o subvol=home,compress=zstd,noatime /dev/sdX2 /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/sdX2 /mnt/nix
```

#### 2. Gerar Configuração Física e Clonar
Gere a configuração física base na estrutura montada:
```bash
nixos-generate-config --root /mnt
```

Instale temporariamente o Git na ISO para clonar as configurações no diretório correto:
```bash
nix-shell -p git
git clone -b experimental https://github.com/gsouza/nixos-config.git /mnt/home/gsouza/.config/nixos
```

Mova o arquivo de hardware recém-gerado da máquina para a pasta de dotfiles:
```bash
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/gsouza/.config/nixos/hosts/default/hardware-configuration.nix
```

#### 3. Executar o Instalador
Navegue ao repositório clonado e inicie a compilação e instalação:
```bash
cd /mnt/home/gsouza/.config/nixos
nixos-install --flake .#nixos
```
Ao terminar, defina a senha para o usuário `gsouza`, remova a mídia de boot e reinicie a máquina.

---

## Filosofia da Branch `experimental`

Esta branch foca em um sistema limpo, modular e altamente responsivo:
*   **Temas GTK & Qt Dinâmicos:** Mantém apenas as configurações recomendadas pelo Noctalia (com Home Manager destravado para `gtk.css`), deixando que o motor de temas escreva livremente em `~/.config/gtk-4.0` e `~/.config/qt6ct` em tempo real.
*   **Modo Escuro Simplificado:** Não faz uso de wrappers complexos ou hacks de variáveis para forçar temas em aplicativos empacotados em AppImages ou isolados. Os que não herdam o tema dinâmico rodam no modo escuro padrão do sistema provido pelo portal (`color-scheme = prefer-dark`).
*   **Template Dinâmico no Nixvim:** Nixvim integrado ao template de Neovim do Noctalia. O plugin `base16-nvim` carrega dinamicamente a paleta de cores gerada pelo `matugen.lua` em `~/.config/nvim/lua/matugen.lua` e reage em tempo real a atualizações via sinal `SIGUSR1`.
*   **Nix Helper (`nh`):** Totalmente integrado para simplificar o gerenciamento e a limpeza segura do sistema.

---

## Alternando entre as Configurações (main / experimental)

Como o NixOS compila e aplica o estado atual da pasta física `~/.config/nixos`, trocar de configuração do sistema é tão simples quanto trocar de branch no Git e rodar o switch do Nix:

1.  **Entrar no modo seguro (estável):**
    ```bash
    git checkout main && nh os switch
    ```
2.  **Voltar para o modo experimental (desenvolvimento):**
    ```bash
    git checkout experimental && nh os switch
    ```

> [!NOTE]
> * **Arquivos não rastreados:** Lembre-se de dar `git add` ou `git stash` antes de mudar de branch, pois o Nix Flake lê apenas arquivos que estão sob o controle do Git.
> * **Compatibilidade:** Para que o switch simplificado sem parâmetros funcione em ambas as ramificações, a branch `main` deve possuir a mesma renomeação do host em seu `flake.nix` (`nixosConfigurations.nixos`).

---

## Gerenciamento e Reconstrução (Switch)

Após a inicialização do sistema, todas as modificações nas configurações devem ser realizadas no repositório local e aplicadas utilizando o Git e o `nh`.

1.  **Navegar ao repositório:**
    ```bash
    cd ~/.config/nixos
    ```

2.  **Rastrear arquivos no Git:**
    O Nix Flake ignora qualquer arquivo que não esteja rastreado pelo Git. Antes de tentar reconstruir, adicione novos arquivos ou modificações:
    ```bash
    git add -A
    ```

3.  **Aplicar configurações e atualizar inicializador (Rebuild Switch):**
    ```bash
    nh os switch
    ```

4.  **Testar alterações temporariamente (Sem gravar no menu de boot):**
    ```bash
    nh os test
    ```
