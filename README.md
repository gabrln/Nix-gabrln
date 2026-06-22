# Configuração Declarativa NixOS (MangoWM + Noctalia)

Este repositório contém a configuração declarativa do sistema operacional NixOS para o usuário gsouza, estruturada utilizando Nix Flakes e Home Manager. A interface gráfica é composta pelo compositor MangoWM e pela suite Noctalia Shell.

## Estrutura do Repositório

```text
nixos-config/
├── flake.nix                       # Ponto de entrada do Nix Flake com canais (26.05) e inputs
├── flake.lock                      # Travamento de versões exatas de dependências externas
├── README.md                       # Guia técnico de instalação e arquitetura
├── vars.nix                        # Variáveis globais do sistema (User, Host, Localização)
├── hosts/
│   └── default/                    # Configurações específicas deste computador (Host Profile)
│       ├── default.nix             # Entrada do host (GRUB, ZRAM, Steam, MangoWM)
│       ├── hardware-configuration.nix # Mapeamento de hardware gerado pelo instalador (UUIDs/SSD)
│       ├── services.nix            # Pipewire, greetd, earlyoom, bluetooth, portals
│       ├── packages.nix            # Pacotes de sistema globais
│       └── docker.nix              # Virtualização de contêineres Docker nativo
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
4. **Virtualização:** Docker nativo habilitado para gerenciamento e execução de contêineres do usuário.

---

## Gerenciamento de Hosts (Melhores Práticas / Modelo Ideal)

A arquitetura ideal para dotfiles no NixOS (inspirada nos repositórios `zaneyos`, `nixy` e `frost-phoenix`) baseia-se na **modularização e independência de hardware**. Separamos o que é configuração lógica e estética (que roda em qualquer máquina) daquilo que é hardware físico puro (discos e partições).

### 1. Separação de Responsabilidade
- **`/modules`**: Módulos globais independentes de máquina.
- **`/hosts`**: Contém perfis de computadores reais. Cada pasta representa um computador com seu respectivo `hardware-configuration.nix` gerado automaticamente na instalação física.

### 2. Fluxo de Trabalho com Novo Computador
Se no futuro você quiser instalar esta mesma configuração em outro notebook ou desktop, você não precisa apagar ou alterar a configuração atual. Basta:
1. Copiar a pasta `hosts/default` com outro nome, ex: `hosts/notebook`.
2. Rodar o instalador gráfico (Calamares) nessa nova máquina.
3. Copiar o `/etc/nixos/hardware-configuration.nix` gerado no notebook para a pasta `hosts/notebook/hardware-configuration.nix`.
4. Registrar o novo perfil no `flake.nix` em `nixosConfigurations.notebook`.
5. Aplicar as alterações rodando `nh os switch --hostname notebook`.

Isso mantém o seu repositório de dotfiles limpo, escalável e 100% livre de conflitos de UUIDs de disco ou particularidades físicas de cada máquina!

---

## Guia de Instalação e Implantação (Pós-Instalação Gráfica)

Este é o método ideal (Método 1) e mais utilizado pela comunidade NixOS, pois deixa o instalador gráfico cuidar do particionamento, UUIDs e montagem básica, aplicando as suas dotfiles logo em seguida:

1. **Instalação Gráfica Base**:
   Realize a instalação do NixOS usando a imagem ISO oficial com interface gráfica (Calamares). Defina suas partições (ext4 padrão), fuso horário e usuário normalmente.

2. **Primeira Inicialização**:
   Inicialize o novo sistema instalado no SSD e abra o terminal.

3. **Clonar suas Configurações**:
   Use o Nix shell para obter temporariamente o Git e clonar a branch `experimental` no diretório de dotfiles local:
   ```bash
   nix-shell -p git
   git clone -b experimental https://github.com/gabrln/Nix-gabrln.git ~/.config/nixos
   ```

4. **Copiar o Hardware Físico Gerado**:
   Copie o `hardware-configuration.nix` criado automaticamente pelo instalador do sistema para dentro do seu repositório (sobrescrevendo o modelo genérico do Git com os UUIDs reais do seu disco):
   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/default/hardware-configuration.nix
   ```

5. **Aplicar e Reconstruir o Sistema**:
   Entre na pasta e execute a reconstrução do flake para aplicar as dotfiles, MangoWM, Noctalia, limites de versões e Docker:
   ```bash
   cd ~/.config/nixos
   git add hosts/default/hardware-configuration.nix
   sudo nixos-rebuild switch --flake .#gabrln
   ```

6. **Pronto**:
   O sistema aplicará as configurações, instalará o compositor e reiniciará no seu novo ambiente modular. Para futuras atualizações, você pode rodar o comando direto pelo Nix Helper (`nh`):
   ```bash
   nh os switch
   ```

### ⚠️ Dicas e Solução de Problemas Pós-Instalação (Lições Aprendidas)

Durante a nossa instalação de validação, identificamos alguns pontos de atenção importantes:

1. **Permissões do Git (Diretório Duvidoso / Dubious Ownership)**:
   Ao rodar `nixos-rebuild` como `root`, o Git pode recusar a leitura do repositório clonado pelo usuário comum devido a regras de segurança de propriedade de pasta.
   * **Solução**: Configure o Git para considerar o diretório confiável rodando (como root):
     ```bash
     git config --global --add safe.directory /home/gsouza/.config/nixos
     ```
     *(Substitua o caminho se o seu repositório estiver em `/home/gabrln` ou outro diretório).*

2. **Senha do Usuário no Primeiro Login**:
   Em instalações manuais, a conta do usuário pode iniciar travada ou sem senha definida pelo instalador gráfico.
   * **Solução**: Definimos declarativamente `initialPassword = "nixos";` no `modules/nixos/base.nix`. O primeiro login do usuário `gsouza` usará a senha `nixos` (que você deve alterar logo em seguida com `passwd`). Se precisar alterar a senha como root no TTY, basta rodar `passwd gsouza`.

3. **Ordem de Execução de Scripts de Ativação**:
   Scripts personalizados definidos em `system.activationScripts` que manipulam permissões de usuários ou grupos (como `chown greeter:greeter`) devem **obrigatoriamente** declarar a dependência `deps = [ "users" ];`. Sem isso, o script pode rodar antes da criação física das contas e grupos pelo NixOS, gerando o erro de compilação `invalid group: 'greeter:greeter'`.

---

## Filosofia da Branch `experimental`

Esta branch foca em um sistema limpo, modular e altamente responsivo:
*   **Temas GTK & Qt Dinâmicos:** Mantém apenas as configurações recomendadas pelo Noctalia (com Home Manager destravado para `gtk.css`), deixando que o motor de temas escreva livremente em `~/.config/gtk-4.0` e `~/.config/qt6ct` em tempo real.
*   **Modo Escuro Simplificado:** Não faz uso de wrappers complexos para forçar temas. Os que não herdam o tema dinâmico rodam no modo escuro padrão do sistema provido pelo portal (`color-scheme = prefer-dark`).
*   **Template Dinâmico no Nixvim:** Nixvim integrado ao template de Neovim do Noctalia. O plugin `base16-nvim` carrega dinamicamente a paleta de cores gerada pelo `matugen.lua`.
*   **Nix Helper (`nh`):** Totalmente integrado para simplificar o gerenciamento e a limpeza segura do sistema.
*   **Limitação de Versões**: O sistema preserva apenas **3 gerações no boot loader** (GRUB) e **10 gerações totais no sistema** (`nh` clean) para evitar ocupação excessiva do SSD e simplificar a restauração.

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
