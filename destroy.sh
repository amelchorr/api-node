#!/bin/bash

echo '==========================='
echo '=== ARCHIVO DE LIMPIEZA ==='
echo '==========================='

echo 'Paso 1.- Limpieza en Contenedores'
docker rm -fv mongodb api-node-devops
docker network rm devops-net 
docker image rm mongo
docker image rm api-node-devops

echo 'Paso 2.- Limpieza en Directorios'
sudo rm -rRf ./database-data
sudo rm -rRf ./database-key