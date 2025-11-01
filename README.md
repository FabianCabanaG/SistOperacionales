# SistOperacionales

How to:

Se requiere tener docker instalado. En windows es más sencillo si se usa WSL - Esto fue probado en un Mac usando podman. 

Se ejecuta el init.sh - Crea una network llamdada ubuntu_network, descarga la imagen de ubuntu que se va a usar, crea 3 contenedores y los integra a la red (los últimos 3 logs son los ids de los contenedores creados). 

Entre ellos se puede interactuar:

docker exec -it <CONTAINER_ID> bash

--> hostname -I en cada una de las máquinas para 

luego:

apt update && apt install -y iputils-ping

ping <output_hostname> -c 10

