#!/usr/bin/env bash

# Script para probar la conectividad entre contenedores
# Instala ping y verifica comunicación entre m1, m2 y m3

echo "🧪 Iniciando pruebas de conectividad..."
echo ""

# Verificar que los contenedores existan
echo "🔍 Verificando que los contenedores estén en ejecución..."
if ! docker ps | grep -q "m1\|m2\|m3"; then
    echo "❌ Error: Los contenedores no están en ejecución"
    echo "   Ejecuta ./init.sh primero"
    exit 1
fi
echo "  ✅ Contenedores encontrados"
echo ""

# Instalar iputils-ping en todos los contenedores
echo "📦 Instalando herramientas de red en los contenedores..."
for container in m1 m2 m3; do
    echo "  → Instalando en $container..."
    docker exec $container bash -c "apt update > /dev/null 2>&1 && apt install -y iputils-ping > /dev/null 2>&1"
    if [ $? -eq 0 ]; then
        echo "    ✅ $container listo"
    else
        echo "    ❌ Error instalando en $container"
    fi
done

echo ""
echo "🌐 Obteniendo IPs de los contenedores..."
M1_IP=$(docker exec m1 hostname -I | xargs)
M2_IP=$(docker exec m2 hostname -I | xargs)
M3_IP=$(docker exec m3 hostname -I | xargs)

echo "  m1: $M1_IP"
echo "  m2: $M2_IP"
echo "  m3: $M3_IP"

echo ""
echo "🏓 Probando conectividad..."
echo ""

# Prueba 1: m1 -> m2
echo "📡 Prueba 1: m1 -> m2"
if docker exec m1 ping -c 3 m2 > /dev/null 2>&1; then
    echo "  ✅ m1 puede comunicarse con m2"
else
    echo "  ❌ m1 NO puede comunicarse con m2"
fi

# Prueba 2: m1 -> m3
echo "📡 Prueba 2: m1 -> m3"
if docker exec m1 ping -c 3 m3 > /dev/null 2>&1; then
    echo "  ✅ m1 puede comunicarse con m3"
else
    echo "  ❌ m1 NO puede comunicarse con m3"
fi

# Prueba 3: m2 -> m3
echo "📡 Prueba 3: m2 -> m3"
if docker exec m2 ping -c 3 m3 > /dev/null 2>&1; then
    echo "  ✅ m2 puede comunicarse con m3"
else
    echo "  ❌ m2 NO puede comunicarse con m3"
fi

# Prueba 4: m3 -> m1
echo "📡 Prueba 4: m3 -> m1"
if docker exec m3 ping -c 3 m1 > /dev/null 2>&1; then
    echo "  ✅ m3 puede comunicarse con m1"
else
    echo "  ❌ m3 NO puede comunicarse con m1"
fi

echo ""
echo "✅ Pruebas de conectividad completadas!"
echo ""
echo "💡 Para ver detalles de la red usa:"
echo "   docker network inspect ubuntu_network"
