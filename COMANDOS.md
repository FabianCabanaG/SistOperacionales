# Guía de Comandos - SistOperacionales

Esta guía contiene todos los comandos útiles para trabajar con los contenedores Docker del proyecto.

## 🚀 Inicialización

### Usando el script (recomendado)
```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x init.sh

# Ejecutar el script
./init.sh

# En PowerShell/Windows
wsl bash init.sh
```

### Usando Docker Compose (alternativa)
```bash
# Iniciar todos los contenedores
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener todo
docker-compose down
```

## 🔍 Inspección y Monitoreo

### Ver contenedores
```bash
# Ver contenedores en ejecución
docker ps

# Ver todos los contenedores (incluso detenidos)
docker ps -a

# Ver solo los contenedores de este proyecto
docker ps --filter "network=ubuntu_network"

# Ver contenedores con formato personalizado
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Ver información de red
```bash
# Listar todas las redes
docker network ls

# Inspeccionar la red ubuntu_network
docker network inspect ubuntu_network

# Ver solo las IPs asignadas
docker network inspect ubuntu_network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{println}}{{end}}'
```

### Ver imágenes
```bash
# Listar todas las imágenes
docker images

# Ver solo la imagen de Ubuntu
docker images ubuntu
```

## 🖥️ Acceso a Contenedores

### Entrar a un contenedor
```bash
# Entrar de forma interactiva con bash
docker exec -it m1 bash
docker exec -it m2 bash
docker exec -it m3 bash

# Salir del contenedor (dentro del contenedor)
exit
# o presionar Ctrl+D
```

### Ejecutar comandos sin entrar
```bash
# Obtener la IP de un contenedor
docker exec m1 hostname -I

# Ver información del sistema operativo
docker exec m1 cat /etc/os-release

# Ver procesos en ejecución
docker exec m1 ps aux

# Ver uso de memoria
docker exec m1 free -h

# Ver uso de disco
docker exec m1 df -h
```

## 📦 Instalación de Paquetes

### Instalar herramientas de red en un contenedor
```bash
# Actualizar repositorios e instalar ping
docker exec m1 bash -c "apt update && apt install -y iputils-ping"

# Instalar múltiples herramientas
docker exec m1 bash -c "apt update && apt install -y iputils-ping net-tools curl wget nano"
```

### Instalar en todos los contenedores
```bash
# Script simple para instalar en todos
for container in m1 m2 m3; do
    echo "Instalando en $container..."
    docker exec $container bash -c "apt update && apt install -y iputils-ping"
done
```

## 🌐 Pruebas de Conectividad

### Ping entre contenedores
```bash
# Desde m1 hacia m2 (por hostname)
docker exec m1 ping m2 -c 4

# Desde m1 hacia m3 (por IP)
docker exec m1 ping 172.19.0.4 -c 4

# Ping continuo (Ctrl+C para detener)
docker exec m1 ping m2
```

### Usando el script de pruebas
```bash
# Ejecutar todas las pruebas automáticamente
chmod +x test-connectivity.sh
./test-connectivity.sh

# En PowerShell/Windows
wsl bash test-connectivity.sh
```

### Traceroute
```bash
# Instalar traceroute
docker exec m1 apt install -y traceroute

# Hacer traceroute a otro contenedor
docker exec m1 traceroute m2
```

## 📊 Logs y Monitoreo

### Ver logs de contenedores
```bash
# Ver logs de un contenedor
docker logs m1

# Ver logs en tiempo real (seguir)
docker logs -f m1

# Ver últimas 50 líneas
docker logs --tail 50 m1

# Ver logs con timestamps
docker logs -t m1
```

### Estadísticas de recursos
```bash
# Ver uso de CPU, memoria, red en tiempo real
docker stats

# Ver stats de un solo contenedor
docker stats m1

# Ver stats una sola vez (no continuo)
docker stats --no-stream
```

## 🛠️ Gestión de Contenedores

### Iniciar/Detener/Reiniciar
```bash
# Detener un contenedor
docker stop m1

# Iniciar un contenedor detenido
docker start m1

# Reiniciar un contenedor
docker restart m1

# Detener todos los contenedores del proyecto
docker stop m1 m2 m3

# Iniciar todos
docker start m1 m2 m3
```

### Copiar archivos
```bash
# Copiar archivo desde host al contenedor
docker cp archivo.txt m1:/root/

# Copiar archivo desde contenedor al host
docker cp m1:/root/archivo.txt ./

# Copiar directorio completo
docker cp m1:/var/log/ ./logs/
```

## 🧹 Limpieza

### Usando el script de limpieza (recomendado)
```bash
# Dar permisos de ejecución (solo la primera vez)
chmod +x cleanup.sh

# Ejecutar el script
./cleanup.sh

# En PowerShell/Windows
wsl bash cleanup.sh
```

### Limpieza manual
```bash
# Eliminar contenedores (forzar si están corriendo)
docker rm -f m1 m2 m3

# Eliminar la red
docker network rm ubuntu_network

# Eliminar la imagen de Ubuntu (opcional)
docker rmi ubuntu:22.04
```

### Limpieza general de Docker
```bash
# Eliminar todos los contenedores detenidos
docker container prune

# Eliminar todas las imágenes sin usar
docker image prune

# Eliminar todas las redes sin usar
docker network prune

# Limpieza completa (cuidado!)
docker system prune -a
```

## 🔧 Solución de Problemas

### Problema: Red ya existe
```bash
# Eliminar la red existente
docker network rm ubuntu_network

# Volver a ejecutar init.sh
./init.sh
```

### Problema: Contenedor con ese nombre ya existe
```bash
# Eliminar contenedores existentes
docker rm -f m1 m2 m3

# Volver a ejecutar init.sh
./init.sh
```

### Problema: No puedo hacer ping
```bash
# Verificar que iputils-ping esté instalado
docker exec m1 which ping

# Si no está instalado
docker exec m1 bash -c "apt update && apt install -y iputils-ping"

# Verificar conectividad de red
docker network inspect ubuntu_network
```

### Problema: Contenedor no responde
```bash
# Ver logs del contenedor
docker logs m1

# Reiniciar el contenedor
docker restart m1

# Ver procesos dentro del contenedor
docker exec m1 ps aux

# Inspeccionar el contenedor
docker inspect m1
```

## 📚 Comandos Avanzados

### Crear snapshot de un contenedor
```bash
# Crear imagen desde un contenedor modificado
docker commit m1 mi-ubuntu-custom:1.0

# Usar la imagen personalizada
docker run -dit --name m4 --network ubuntu_network mi-ubuntu-custom:1.0
```

### Exportar/Importar contenedores
```bash
# Exportar contenedor a archivo tar
docker export m1 > m1-backup.tar

# Importar desde archivo tar
cat m1-backup.tar | docker import - mi-ubuntu-imported:latest
```

### Limitar recursos
```bash
# Crear contenedor con límite de memoria
docker run -dit --name m4 --memory="512m" --network ubuntu_network ubuntu:22.04 bash

# Crear contenedor con límite de CPU
docker run -dit --name m5 --cpus="0.5" --network ubuntu_network ubuntu:22.04 bash
```

## 🎓 Comandos Útiles de Linux (dentro del contenedor)

Una vez dentro del contenedor (`docker exec -it m1 bash`):

```bash
# Ver información del sistema
uname -a
cat /etc/os-release

# Ver interfaces de red
ip addr show
ip link show

# Ver tabla de rutas
ip route

# Ver información de memoria
free -h

# Ver uso de disco
df -h

# Ver procesos
ps aux
top

# Instalar editor de texto
apt update && apt install -y nano vim

# Crear archivo de prueba
echo "Hola desde m1" > /tmp/test.txt

# Transferir archivo a otro contenedor (requiere ssh o usar docker cp)
```

## 💡 Tips y Trucos

### Ejecutar múltiples comandos
```bash
# Ejecutar varios comandos en secuencia
docker exec m1 bash -c "apt update && apt install -y iputils-ping net-tools && hostname -I"
```

### Usar alias (en tu terminal local)
```bash
# Agregar a tu .bashrc o .zshrc
alias m1="docker exec -it m1 bash"
alias m2="docker exec -it m2 bash"
alias m3="docker exec -it m3 bash"

# Ahora solo escribe:
m1  # para entrar a m1
```

### Ver diferencias entre contenedor e imagen
```bash
# Ver qué archivos han cambiado
docker diff m1
```

### Backup de toda la configuración
```bash
# Exportar la configuración de la red
docker network inspect ubuntu_network > network-backup.json

# Guardar lista de contenedores
docker ps -a > containers-backup.txt
```

---

**Nota**: Para más información sobre comandos Docker, consulta la [documentación oficial de Docker](https://docs.docker.com/engine/reference/commandline/cli/).
