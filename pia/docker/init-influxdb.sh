#!/bin/bash
set -e

echo "⏳ Esperando a que InfluxDB esté listo..."

# Esperamos hasta que InfluxDB esté accesible
until influx ping &> /dev/null; do
  echo "🔄 InfluxDB aún no está disponible... reintentando en 2 segundos"
  sleep 2
done

echo "✅ InfluxDB activo. Generando token adicional..."

# ==========================================================
# 1️⃣ Crear token adicional de lectura/escritura compartido
# ==========================================================
TOKEN=$(influx auth create \
  --org "${DOCKER_INFLUXDB_INIT_ORG}" \
  --description "Shared Read-Write Token" \
  --read-buckets \
  --write-buckets \
  --token "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}" \
  --json | awk -F'"' '/"token":/{print $4}')

if [ -n "$TOKEN" ]; then
    echo "$TOKEN" > /shared/api-token.txt
    echo "✅ Token adicional guardado en /shared/api-token.txt"
else
    echo "❌ Error: No se pudo generar el token"
    exit 1
fi

# ==========================================================
# 2️⃣ Crear bucket RETO0-PANDAS si no existe
# ==========================================================
echo "🪣 Verificando bucket RETO0-PANDAS..."

# Comprobar si ya existe
if influx bucket list --org "${DOCKER_INFLUXDB_INIT_ORG}" --token "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}" | grep -q "RETO0-PANDAS"; then
    echo "ℹ️ El bucket RETO0-PANDAS ya existe. No se crea de nuevo."
else
    echo "📦 Creando bucket RETO0-PANDAS..."
    influx bucket create \
      --name "RETO0-PANDAS" \
      --org "${DOCKER_INFLUXDB_INIT_ORG}" \
      --token "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}"
    echo "✅ Bucket RETO0-PANDAS creado correctamente."
fi

# ==========================================================
# 3️⃣ Mostrar resumen final
# ==========================================================
echo "✅ Configuración de InfluxDB completada correctamente."
echo "📄 Token guardado en: /shared/api-token.txt"
echo "📦 Buckets disponibles:"
influx bucket list --org "${DOCKER_INFLUXDB_INIT_ORG}" --token "${DOCKER_INFLUXDB_INIT_ADMIN_TOKEN}" | grep "RETO0"
