#!/bin/bash
echo "========================================="
echo " 🧹 Limpiando entorno Docker del proyecto PIA..."
echo "========================================="

# Ir a la carpeta donde está el docker-compose.yml
cd "$(dirname "$0")"

# Parar y eliminar contenedores + volúmenes
docker compose down -v

# Eliminar imágenes personalizadas (si existen)
# docker image rm -f docker-nodered docker-pandas_script 2>/dev/null || true   # Se deja comentado para no eliminar las imagenes simplemente se refresquen,

# Mostrar estado final
echo
echo "📋 Contenedores restantes:"
docker ps -a
echo
echo "📦 Volúmenes restantes:"
docker volume ls
echo
echo "✅ Entorno limpio. Puedes ejecutar './start_all.sh' desde automation/"
echo "========================================="
