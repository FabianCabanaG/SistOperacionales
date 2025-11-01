#!/usr/bin/env bash

# Script para limpiar todos los recursos creados por init.sh
# Elimina contenedores y la red ubuntu_network

echo "🧹 Iniciando limpieza de recursos..."
echo ""

# Detener y eliminar contenedores
echo "🛑 Deteniendo y eliminando contenedores..."
docker rm -f m1 m2 m3 2>/dev/null

if [ $? -eq 0 ]; then
    echo "  ✅ Contenedores m1, m2, m3 eliminados"
else
    echo "  ⚠️  No se encontraron contenedores para eliminar"
fi

echo ""

# Eliminar la red
echo "🌐 Eliminando red ubuntu_network..."
docker network rm ubuntu_network 2>/dev/null

if [ $? -eq 0 ]; then
    echo "  ✅ Red ubuntu_network eliminada"
else
    echo "  ⚠️  No se encontró la red ubuntu_network"
fi

echo ""
echo "✅ Limpieza completada!"
echo ""
echo "📋 Recursos restantes:"
echo "Contenedores:"
docker ps -a | grep -E "m1|m2|m3" || echo "  Ninguno"
echo ""
echo "Redes:"
docker network ls | grep ubuntu_network || echo "  Ninguna"
