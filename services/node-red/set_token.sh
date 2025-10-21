#!/bin/bash
echo "🔧 Sustituyendo token en flujo Node-RED..."

# Leer el token directamente desde variable de entorno pasada desde docker-compose
TOKEN=${INFLUXDB_TOKEN}

# Si no se encuentra, intentar leer desde archivo .env montado (opcional)
if [ -z "$TOKEN" ] && [ -f /data/.env ]; then
  TOKEN=$(grep INFLUXDB_TOKEN /data/.env | cut -d '=' -f2)
fi

# Validar que tenemos un token
if [ -z "$TOKEN" ]; then
  echo "❌ No se pudo obtener el token InfluxDB. Abortando."
  exit 1
fi

# Reemplazar la línea en flows.json
sed -i "s/\"token\": \"\"/\"token\": \"${TOKEN}\"/" /data/flows.json

echo "✅ Token InfluxDB insertado correctamente en flows.json"
