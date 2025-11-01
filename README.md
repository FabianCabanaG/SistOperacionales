# SistOperacionales

Este repositorio contiene scripts y contenedores Docker/Podman para experimentar con máquinas Ubuntu conectadas en una red virtual.

## Requisitos

- **Docker** (o Podman)
  - En **Windows**: se recomienda usar **WSL2** y ejecutar los scripts desde una terminal WSL/Bash
  - En **macOS**: este proyecto fue probado exitosamente con Podman
- **Shell**: Bash (recomendado). Para PowerShell en Windows, prefiera ejecutar dentro de WSL o anteponer `wsl` a los comandos

## ¿Qué hace `init.sh`?

El script `init.sh` automatiza la configuración del entorno:

1. Crea una red Docker llamada `ubuntu_network`
2. Descarga la imagen de Ubuntu 22.04 (si no está presente)
3. Crea 3 contenedores Ubuntu (`m1`, `m2`, `m3`) y los conecta a la red
4. Cada contenedor tiene su propio hostname para facilitar la identificación

## Uso rápido

### En Bash/WSL (recomendado)

```bash
# Dar permiso de ejecución si hace falta
chmod +x init.sh

# Ejecutar el script
./init.sh
```

### En PowerShell (Windows sin WSL)

```powershell
# Ejecutar dentro de WSL
wsl ./init.sh
```

## Interacción entre contenedores

### 1. Acceder a un contenedor

Puedes usar el ID del contenedor o su nombre:

```bash
docker exec -it m1 bash
# o
docker exec -it <CONTAINER_ID> bash
```

### 2. Obtener la IP del contenedor

Dentro del contenedor, ejecuta:

```bash
hostname -I
```

También puedes usar:

```bash
ip addr show
```

### 3. Instalar utilidades de red

Para poder hacer `ping` entre contenedores, instala las herramientas necesarias:

```bash
apt update && apt install -y iputils-ping
```

### 4. Probar conectividad entre contenedores

Puedes hacer ping usando la IP o el hostname:

```bash
# Por IP
ping <IP_DEL_OTRO_CONTENEDOR> -c 10

# Por hostname (más fácil)
ping m2 -c 10
```

## Ejemplo de flujo completo

```bash
# 1. Ejecutar el script de inicialización
./init.sh

# 2. Ver los contenedores creados
docker ps

# 3. Entrar en el primer contenedor (m1)
docker exec -it m1 bash

# 4. Obtener su IP
hostname -I
# Ejemplo de salida: 172.18.0.2

# 5. Instalar ping
apt update && apt install -y iputils-ping

# 6. Hacer ping al segundo contenedor (m2) por hostname
ping m2 -c 10

# 7. Hacer ping al tercer contenedor (m3) por hostname
ping m3 -c 10

# 8. Salir del contenedor
exit
```

## Comandos útiles adicionales

```bash
# Ver todos los contenedores en ejecución
docker ps

# Ver detalles de la red y las IPs asignadas
docker network inspect ubuntu_network

# Listar todas las redes Docker
docker network ls

# Ver los logs de un contenedor
docker logs m1

# Ejecutar un comando sin entrar al contenedor
docker exec m1 hostname -I
```

## Limpiar los recursos

```bash
# Detener y eliminar los contenedores
docker rm -f m1 m2 m3

# Eliminar la red creada
docker network rm ubuntu_network

# O eliminar todos los contenedores detenidos
docker container prune

# Ver qué recursos quedan
docker ps -a
docker network ls
```

## Solución de problemas

### `./init.sh` falla en PowerShell
**Solución**: Ejecutar `wsl ./init.sh` o usar Git Bash/WSL directamente

### Error: "network ubuntu_network already exists"
**Solución**: La red ya existe de una ejecución anterior. Elimínala primero:
```bash
docker network rm ubuntu_network
```

### Error: "container name already in use"
**Solución**: Los contenedores ya existen. Elimínalos primero:
```bash
docker rm -f m1 m2 m3
```

### `hostname -I` no devuelve nada
**Solución**: Usar `ip addr show` o instalar `net-tools` si es necesario

### No puedo hacer ping entre contenedores
**Verificar**:
- Que ambos contenedores estén en la misma red: `docker network inspect ubuntu_network`
- Que `iputils-ping` esté instalado en ambos contenedores
- Que los contenedores estén en ejecución: `docker ps`

## Arquitectura

```
ubuntu_network (bridge)
    ├── m1 (hostname: m1, ubuntu:22.04)
    ├── m2 (hostname: m2, ubuntu:22.04)
    └── m3 (hostname: m3, ubuntu:22.04)
```

Todos los contenedores pueden comunicarse entre sí usando sus hostnames (`m1`, `m2`, `m3`) o sus IPs asignadas automáticamente por Docker.

## Mejoras sugeridas

- Crear un `docker-compose.yml` para orquestar los contenedores más fácilmente
- Añadir un script `cleanup.sh` para eliminar automáticamente los recursos creados
- Implementar pruebas automatizadas de conectividad
- Agregar volúmenes compartidos entre contenedores

## Licencia

Este proyecto está disponible bajo la licencia MIT.



