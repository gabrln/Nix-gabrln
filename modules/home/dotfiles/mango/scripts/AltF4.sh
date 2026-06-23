#!/usr/bin/env bash
# AltF4 script to force kill the focused window in MangoWM.

# Get active window info in JSON format from MangoWM
info=$(mmsg get focusing-client 2>/dev/null)

if [[ -z "$info" ]]; then
  # Send error notification if no window is focused
  notify-send -t 3000 -a "Sistema" -i dialog-error "Erro ao Encerrar" "Nenhum processo em foco localizado."
  exit 1
fi

# Extract fields using jq
pid=$(echo "$info" | jq -r '.pid // empty')
appid=$(echo "$info" | jq -r '.appid // "Desconhecido"')
title=$(echo "$info" | jq -r '.title // "Aplicativo"')

# Safety list of core processes that Alt+F4 must never terminate
protected_apps=("noctalia" "mango" "mangowc" "systemd" "dbus-daemon" "dbus-broker" "Xwayland" "pipewire" "wireplumber" "greetd")

# Check if application class/title matches protected core systems
for protected in "${protected_apps[@]}"; do
  if [[ "${appid,,}" == *"${protected,,}"* ]] || [[ "${title,,}" == *"${protected,,}"* ]]; then
    notify-send -t 3000 -a "Sistema" -i dialog-error "Acesso Negado" "Não é permitido encerrar o processo do sistema: $title"
    exit 1
  fi
done

# Check if PID belongs to system/root services (usually PIDs <= 1000)
if [[ -n "$pid" ]] && [[ "$pid" -le 1000 ]]; then
  notify-send -t 3000 -a "Sistema" -i dialog-error "Acesso Negado" "Não é permitido encerrar processos do sistema (PID: $pid)"
  exit 1
fi

# Terminate process if PID is valid
if [[ -n "$pid" ]]; then
  # Force kill the process by PID
  kill -9 "$pid"
  
  # Send successful kill notification styled by Noctalia
  notify-send -t 4000 -a "Sistema" -i dialog-warning "Processo Encerrado" "O processo <b>$title</b> (PID: $pid, AppID: $appid) foi encerrado forçadamente."
else
  # Fallback to default MangoWM kill client method if PID is not found
  mmsg dispatch killclient
  notify-send -t 3000 -a "Sistema" -i dialog-information "Janela Fechada" "A janela foi fechada pelo método padrão (PID não localizado)."
fi
