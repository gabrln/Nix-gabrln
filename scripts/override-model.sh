#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/nixos/modules/home/dotfiles/opencode/opencode.jsonc"
BACKUP="${CONFIG}.bak"

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <AGENT_MODEL_ENV> <model-id>"
  echo "Agents: ORCHESTRATOR_MODEL, SPEC_MODEL, DESIGN_MODEL, APPLY_MODEL, VERIFY_MODEL, REVIEW_MODEL"
  exit 1
fi

ENV_VAR="$1"
MODEL="$2"

declare -A MODEL_MAP=(
  ["ORCHESTRATOR_MODEL"]="agent.build.model"
  ["SPEC_MODEL"]="agent.spec.model"
  ["DESIGN_MODEL"]="agent.design.model"
  ["APPLY_MODEL"]="agent.apply.model"
  ["VERIFY_MODEL"]="agent.verify.model"
  ["REVIEW_MODEL"]="agent.design-review.model"
)

PATH_JSONC="${MODEL_MAP[$ENV_VAR]:-}"
if [[ -z "$PATH_JSONC" ]]; then
  echo "Unknown env var: $ENV_VAR"
  exit 1
fi

cp "$CONFIG" "$BACKUP"
trap 'mv "$BACKUP" "$CONFIG"' EXIT

nix run nixpkgs#jq -- --arg val "$MODEL" ".$PATH_JSONC = \$val" "$CONFIG" > "${CONFIG}.tmp"
mv "${CONFIG}.tmp" "$CONFIG"

echo "Overridden $ENV_VAR -> $MODEL. Run 'opencode' now."
echo "Config auto-restores on script exit."