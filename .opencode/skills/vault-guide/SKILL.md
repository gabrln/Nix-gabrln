---
name: vault-guide
description: Use when the user mentions formatting, frontmatter, tags, or vault organization in Obsidian. Provides vault structure, YAML frontmatter rules, and tag conventions.
---

# Vault Formatting Reference

## Folder structure

- `B05 Systems/App/Configs/` → config backups (*.nix.md, *.conf.md)
- `B05 Systems/App/` → descriptive guides (* Configuration.md)
- `C04 Agent/` → agent identity, workflow, memory

## Frontmatter (all notes)

```yaml
---
category: Systems | Agent | Archives
tags: [system/nixos, system/configuration, ...]
status: active | reference | archived
source: modules/core/foo.nix  (para Configs/*)
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

## Rules

- Titles: Title Case (English). `System Services.md`, `Git Configuration.md`
- Tags: nested, English. `#system/nixos`, `#agent/workflow`
- Content: pt-BR. Code blocks and technical terms in English.
- `Configs/` dir: literal config copies in code blocks, tag `#system/configuration`
- `source:` frontmatter: path to the .nix file this doc documents
