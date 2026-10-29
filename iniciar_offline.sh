#!/usr/bin/env bash

# Garante navegação para o diretório deste script
cd "$(dirname "$0")"

export PATH="/bin:/usr/bin:/usr/local/bin:/opt/homebrew/bin:/Users/giovani/development/flutter/bin:$PATH"

echo "=========================================================="
echo "👶 BabyOS v1.0 - Modo 100% Offline (Sem Internet)"
echo "=========================================================="

# Sincroniza o resultado.json do projeto para o build local instantaneamente
if [ -f "assets/resultado.json" ]; then
  mkdir -p "build/web/assets/assets"
  cp "assets/resultado.json" "build/web/assets/assets/resultado.json"
  echo "✔ Arquivo assets/resultado.json sincronizado!"
fi

# Se o build local com CanvasKit offline ainda não existir, compila uma vez
if [ ! -f "build/web/canvaskit/canvaskit.wasm" ]; then
  echo "⚡ Compilando pacote offline do Flutter Web..."
  flutter build web --no-web-resources-cdn
fi

# Procura porta disponível (8080 ou 8888)
PORT=8080
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 ; then
  PORT=8888
fi

echo "🚀 Iniciando servidor local na porta $PORT..."
python3 -m http.server $PORT --directory build/web &
SERVER_PID=$!

cleanup() {
  echo ""
  echo "🛑 Encerrando servidor local..."
  kill $SERVER_PID 2>/dev/null
  exit 0
}

trap cleanup SIGINT SIGTERM EXIT

sleep 1

URL="http://localhost:$PORT"
echo "🌐 Abrindo navegador: $URL"
open -a "Google Chrome" "$URL" 2>/dev/null || open "$URL"

echo ""
echo "🎉 BabyOS rodando 100% OFFLINE!"
echo "👉 DICA: Pressione F11 (ou Cmd + Shift + F no macOS) para Tela Cheia."
echo "👉 Para fechar o servidor, pressione Ctrl + C nesta janela."
echo "=========================================================="

wait $SERVER_PID
