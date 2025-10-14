#!/bin/bash
# =========================================
# 🚀 Script de inicio de la infraestructura Docker del RETO 0 - PIA
# =========================================

# Nos movemos al directorio donde está este script
cd "$(dirname "$0")"

echo "========================================="
echo " 🚀 Iniciando todos los servicios del proyecto..."
echo "========================================="

# Levantar los servicios definidos en docker-compose con las variables .env
docker compose --env-file ../../.env -f ../docker/docker-compose.yml up -d

# Esperar unos segundos para asegurar que todo arranca
echo "⌛ Esperando a que los servicios estén activos..."
sleep 10

# Mostrar el estado de los contenedores
docker ps

echo "========================================="
echo " ✅ Servicios en ejecución correctamente."
echo " InfluxDB: http://localhost:8086"
echo " Grafana:  http://localhost:3000"
echo " Node-RED: http://localhost:1880"
echo "========================================="
