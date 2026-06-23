#!/usr/bin/env bash
# Query active window metadata from MangoWM in JSON and display via notifications.

info=$(mmsg get focusing-client 2>/dev/null)

if [[ -z "$info" ]]; then
  # Send error notification if MangoWM compositor is not found or no window is focused
  notify-send -t 4000 -a "Sistema" -i dialog-error "Informações da Janela Ativa" "Compositor MangoWM não encontrado ou nenhuma janela focada."
  exit 1
fi

# Extract metadata fields using jq
id=$(echo "$info" | jq -r '.id // "N/A"')
pid=$(echo "$info" | jq -r '.pid // "N/A"')
appid=$(echo "$info" | jq -r '.appid // "N/A"')
title=$(echo "$info" | jq -r '.title // "N/A"')
monitor=$(echo "$info" | jq -r '.monitor // "N/A"')
tags=$(echo "$info" | jq -r '.tags | join(", ") // "N/A"')
floating=$(echo "$info" | jq -r '.is_floating // "false"')
fullscreen=$(echo "$info" | jq -r '.is_fullscreen // "false"')

# Format message body using Pango bold HTML tags
msg="<b>ID:</b> $id\n<b>PID:</b> $pid\n<b>App ID (Classe):</b> $appid\n<b>Título:</b> $title\n<b>Monitor:</b> $monitor\n<b>Área de Trabalho (Tags):</b> $tags\n<b>Flutuante:</b> $floating\n<b>Tela Cheia:</b> $fullscreen"

# Send active window info notification styled by Noctalia
notify-send -t 8000 -a "Sistema" -i dialog-information "Informações da Janela Ativa" "$msg"
