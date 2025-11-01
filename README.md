# SistOperacionales

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

Este repositorio contiene scripts y configuraciones Docker para crear un **entorno de laboratorio virtual** con 3 máquinas Ubuntu conectadas en una red bridge. Ideal para aprender sobre:
- 🌐 Redes y comunicación entre contenedores
- 🐳 Administración de Docker
- 💻 Sistemas operativos Linux
- 🔧 Comandos de red y troubleshooting

## 📋 Tabla de Contenidos

- [Requisitos](#-requisitos)
- [Arquitectura](#-arquitectura)
- [Inicio Rápido](#-inicio-rápido)
- [Scripts Disponibles](#-scripts-disponibles)
- [Archivos del Proyecto](#-archivos-del-proyecto)
- [Uso Detallado](#-uso-detallado)
- [Comandos Útiles](#-comandos-útiles)
- [Solución de Problemas](#-solución-de-problemas)
- [Documentación Adicional](#-documentación-adicional)

## 🔧 Requisitos

- **Docker** (o Podman)
  - En **Windows**: se recomienda usar **WSL2** y ejecutar los scripts desde una terminal WSL/Bash
  - En **macOS**: este proyecto fue probado exitosamente con Podman
  - En **Linux**: Docker instalado y usuario en el grupo `docker`
- **Shell**: Bash (recomendado). Para PowerShell en Windows, prefiera ejecutar dentro de WSL o anteponer `wsl` a los comandos
- **Docker Desktop** (opcional pero recomendado para visualización gráfica)

### Verificar instalación

```bash
# Verificar Docker
docker --version

# Verificar que Docker esté corriendo
docker ps
```

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│              ubuntu_network (bridge)                    │
│              Subnet: 172.19.0.0/16                      │
│              Gateway: 172.19.0.1                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   m1 (m1)    │  │   m2 (m2)    │  │   m3 (m3)    │ │
│  │ 172.19.0.2   │  │ 172.19.0.3   │  │ 172.19.0.4   │ │
│  │ Ubuntu 22.04 │  │ Ubuntu 22.04 │  │ Ubuntu 22.04 │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
│         ▲                 ▲                 ▲          │
│         └─────────────────┴─────────────────┘          │
│              Comunicación bidireccional                │
└─────────────────────────────────────────────────────────┘
```

**Componentes:**
- **Red**: `ubuntu_network` - Red bridge que conecta los 3 contenedores
- **Contenedores**:
  - `m1` (hostname: m1, IP: 172.19.0.2)
  - `m2` (hostname: m2, IP: 172.19.0.3)
  - `m3` (hostname: m3, IP: 172.19.0.4)
- **Imagen base**: Ubuntu 22.04 LTS (117 MB)

## 🚀 Inicio Rápido

### Opción 1: Usando el script `init.sh` (recomendado)

```bash
# 1. Clonar el repositorio
git clone https://github.com/wilmereleon/SistOperacionales.git
cd SistOperacionales

# 2. Dar permisos de ejecución
chmod +x init.sh

# 3. Ejecutar el script
./init.sh

# En PowerShell/Windows
wsl bash init.sh
```

### Opción 2: Usando Docker Compose

```bash
# Iniciar todos los contenedores
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener todo
docker-compose down
```

### Verificar que todo funciona

```bash
# Ver contenedores en ejecución
docker ps

# Probar conectividad automáticamente
chmod +x test-connectivity.sh
./test-connectivity.sh
```

## 📦 Scripts Disponibles

| Script | Descripción | Uso |
|--------|-------------|-----|
| `init.sh` | Inicializa el entorno completo | `./init.sh` |
| `cleanup.sh` | Limpia todos los recursos creados | `./cleanup.sh` |
| `test-connectivity.sh` | Prueba la conectividad entre contenedores | `./test-connectivity.sh` |

### `init.sh` - Inicialización

Automatiza la configuración del entorno:

1. ✅ Crea una red Docker llamada `ubuntu_network`
2. ✅ Descarga la imagen de Ubuntu 22.04 (si no está presente)
3. ✅ Crea 3 contenedores Ubuntu (`m1`, `m2`, `m3`) y los conecta a la red
4. ✅ Muestra un resumen con IPs y comandos útiles

**Salida esperada:**
```
🚀 Iniciando configuración de contenedores Ubuntu...
📡 Creando red ubuntu_network...
📥 Descargando imagen Ubuntu 22.04...
🐳 Creando contenedores...
✅ Configuración completada!
```

### `cleanup.sh` - Limpieza

Elimina todos los recursos creados:
- Detiene y elimina los contenedores `m1`, `m2`, `m3`
- Elimina la red `ubuntu_network`

**Uso:**
```bash
chmod +x cleanup.sh
./cleanup.sh
```

### `test-connectivity.sh` - Pruebas de Conectividad

Verifica automáticamente:
- Instalación de herramientas de red en todos los contenedores
- Conectividad bidireccional entre todos los nodos
- Muestra las IPs asignadas

**Uso:**
```bash
chmod +x test-connectivity.sh
./test-connectivity.sh
```

## 📁 Archivos del Proyecto

```
SistOperacionales/
├── README.md                  # Este archivo
├── COMANDOS.md               # Guía completa de comandos
├── init.sh                   # Script de inicialización
├── cleanup.sh                # Script de limpieza
├── test-connectivity.sh      # Script de pruebas
└── docker-compose.yml        # Configuración Docker Compose
```

## 💻 Uso Detallado

### 1. Acceder a un Contenedor

Puedes usar el ID del contenedor o su nombre:

```bash
# Acceder por nombre (más fácil)
docker exec -it m1 bash

# Acceder por ID
docker exec -it <CONTAINER_ID> bash

# Una vez dentro, verás el prompt cambiar:
root@m1:/#
```

### 2. Obtener información del contenedor


**Ver IP del contenedor:**

```bash
# Dentro del contenedor
hostname -I
# Salida: 172.19.0.2

# Desde fuera del contenedor
docker exec m1 hostname -I

# Ver información más detallada
ip addr show
```

**Ver información del sistema:**

```bash
# Dentro del contenedor
cat /etc/os-release
uname -a
```

### 3. Instalar utilidades de red

Para poder hacer `ping` entre contenedores:

```bash
# Dentro del contenedor
apt update && apt install -y iputils-ping

# O desde fuera
docker exec m1 bash -c "apt update && apt install -y iputils-ping"

# Instalar herramientas adicionales
apt install -y net-tools curl wget nano vim
```

### 4. Probar conectividad entre contenedores

**Por hostname (recomendado):**

```bash
# Desde m1, hacer ping a m2
ping m2 -c 5

# Desde m1, hacer ping a m3
ping m3 -c 5
```

**Por IP:**

```bash
# Hacer ping usando la IP directamente
ping 172.19.0.3 -c 5
```

**Ejemplo de salida exitosa:**
```
PING m2 (172.19.0.3) 56(84) bytes of data.
64 bytes from m2.ubuntu_network (172.19.0.3): icmp_seq=1 ttl=64 time=0.105 ms
64 bytes from m2.ubuntu_network (172.19.0.3): icmp_seq=2 ttl=64 time=0.076 ms
--- m2 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss
```

## 🎯 Ejemplo de Flujo Completo

### Escenario: Probar comunicación entre las 3 máquinas

```bash
# 1. Iniciar el entorno
./init.sh

# 2. Ver los contenedores creados
docker ps

# 3. Entrar al primer contenedor (m1)
docker exec -it m1 bash

# 4. Dentro de m1: Ver su IP
hostname -I
# Salida: 172.19.0.2

# 5. Instalar ping
apt update && apt install -y iputils-ping

# 6. Hacer ping a m2
ping m2 -c 3

# 7. Hacer ping a m3
ping m3 -c 3

# 8. Salir de m1
exit

# 9. Repetir en m2 y m3 si deseas probar desde ellos
docker exec -it m2 bash
# ... (repetir pasos 4-8)

# 10. Limpiar todo al terminar
./cleanup.sh
```

### Escenario: Transferir archivos entre contenedores

```bash
# 1. Entrar a m1
docker exec -it m1 bash

# 2. Crear un archivo de prueba
echo "Hola desde m1" > /tmp/mensaje.txt

# 3. Salir
exit

# 4. Copiar archivo de m1 a host
docker cp m1:/tmp/mensaje.txt ./mensaje.txt

# 5. Copiar archivo del host a m2
docker cp ./mensaje.txt m2:/tmp/mensaje.txt

# 6. Verificar en m2
docker exec m2 cat /tmp/mensaje.txt
```

## 📚 Comandos Útiles

### Gestión de contenedores

```bash
# Ver todos los contenedores
docker ps

# Ver solo los de ubuntu_network
docker ps --filter "network=ubuntu_network"

# Ver logs de un contenedor
docker logs m1

# Ver logs en tiempo real
docker logs -f m1

# Ver estadísticas de recursos
docker stats m1

# Reiniciar un contenedor
docker restart m1

# Detener un contenedor
docker stop m1

# Iniciar un contenedor detenido
docker start m1
```

### Inspección de red

```bash
# Ver detalles de la red
docker network inspect ubuntu_network

# Ver solo las IPs asignadas
docker network inspect ubuntu_network \
  --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{println}}{{end}}'

# Listar todas las redes
docker network ls
```

### Ejecución de comandos

```bash
# Ejecutar comando sin entrar al contenedor
docker exec m1 hostname -I
docker exec m2 cat /etc/os-release
docker exec m3 ps aux

# Ejecutar múltiples comandos
docker exec m1 bash -c "apt update && apt install -y iputils-ping && ping m2 -c 3"
```

### Limpieza y mantenimiento

```bash
# Usar el script de limpieza (recomendado)
./cleanup.sh

# O manual: Eliminar contenedores
docker rm -f m1 m2 m3

# Eliminar la red
docker network rm ubuntu_network

# Eliminar imagen de Ubuntu (opcional)
docker rmi ubuntu:22.04

# Limpieza general de Docker
docker system prune -a
```

## 🔍 Solución de Problemas

### Error: "network ubuntu_network already exists"

**Causa:** La red ya existe de una ejecución anterior.

**Solución:**
```bash
docker network rm ubuntu_network
./init.sh
```

### Error: "container name already in use"

**Causa:** Los contenedores ya existen.

**Solución:**
```bash
docker rm -f m1 m2 m3
./init.sh
```

### Error: `./init.sh` falla en PowerShell

**Causa:** Diferencias entre Bash y PowerShell o ausencia de WSL.

**Solución:**
```powershell
# Ejecutar desde WSL
wsl bash init.sh

# O usar Git Bash
# O instalar WSL2
```

### `hostname -I` no devuelve nada

**Causa:** Utilidades de red no instaladas o imagen mínima.

**Solución:**
```bash
# Dentro del contenedor, usar alternativa
ip addr show

# O instalar net-tools
apt update && apt install -y net-tools iproute2
```

### No puedo hacer ping entre contenedores

**Verificaciones:**

```bash
# 1. Verificar que los contenedores estén corriendo
docker ps

# 2. Verificar que estén en la misma red
docker network inspect ubuntu_network

# 3. Verificar que iputils-ping esté instalado
docker exec m1 which ping

# 4. Si no está instalado
docker exec m1 bash -c "apt update && apt install -y iputils-ping"

# 5. Probar con IP directa
docker exec m1 ping 172.19.0.3 -c 3
```

### Contenedor no responde

```bash
# Ver logs del contenedor
docker logs m1

# Reiniciar el contenedor
docker restart m1

# Inspeccionar el contenedor
docker inspect m1

# Ver procesos dentro del contenedor
docker exec m1 ps aux
```

## 📖 Documentación Adicional

- **[COMANDOS.md](COMANDOS.md)** - Guía completa con todos los comandos útiles
- **[Documentación oficial de Docker](https://docs.docker.com/)**
- **[Docker Compose documentation](https://docs.docker.com/compose/)**
- **[Ubuntu Docker Hub](https://hub.docker.com/_/ubuntu)**

## 🎓 Casos de Uso Educativos

Este proyecto es ideal para:

1. **Aprender networking básico**
   - Entender subredes y direccionamiento IP
   - Practicar comandos de red (ping, traceroute, netstat)
   - Comprender DNS interno de Docker

2. **Experimentar con Linux**
   - Practicar comandos de terminal
   - Instalar y configurar paquetes
   - Gestión de procesos y recursos

3. **Simular entornos distribuidos**
   - Probar aplicaciones cliente-servidor
   - Simular comunicación entre nodos
   - Prácticas de troubleshooting

4. **Introducción a contenedores**
   - Comprender el ciclo de vida de contenedores
   - Entender redes Docker
   - Practicar con volúmenes y persistencia

## 🛠️ Personalizaciones Posibles

### Agregar más contenedores

Editar `init.sh` o `docker-compose.yml`:

```bash
# En init.sh, agregar:
docker run -dit --name m4 --hostname m4 --network ubuntu_network ubuntu:22.04 bash
```

```yaml
# En docker-compose.yml, agregar:
  m4:
    image: ubuntu:22.04
    container_name: m4
    hostname: m4
    networks:
      - ubuntu_network
    stdin_open: true
    tty: true
    command: bash
```

### Cambiar la subnet de la red

```bash
# Al crear la red manualmente
docker network create --driver bridge --subnet 192.168.100.0/24 ubuntu_network
```

### Instalar paquetes por defecto

Crear un `Dockerfile`:

```dockerfile
FROM ubuntu:22.04

RUN apt update && apt install -y \
    iputils-ping \
    net-tools \
    curl \
    wget \
    nano \
    vim

CMD ["bash"]
```

Construir y usar:

```bash
docker build -t mi-ubuntu-custom .
# Luego modificar init.sh para usar mi-ubuntu-custom en vez de ubuntu:22.04
```

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Notas Importantes

- Los pasos mostrados asumen privilegios suficientes para usar Docker
- En entornos corporativos puede que necesites permisos administrativos
- Los contenedores no persisten datos por defecto (usa volúmenes si necesitas persistencia)
- Las IPs se asignan automáticamente por DHCP de Docker

## 📄 Licencia

Este proyecto está disponible bajo la licencia MIT.

## 👤 Autor

**Wilmer León**
- GitHub: [@wilmereleon](https://github.com/wilmereleon)

---

⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub

**¿Preguntas o sugerencias?** Abre un [issue](https://github.com/wilmereleon/SistOperacionales/issues) en GitHub
