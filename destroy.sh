#!/bin/bash

echo '==========================='
echo '=== ARCHIVO DE LIMPIEZA ==='
echo '==========================='

echo 'Paso 1.- Limpieza en Contenedores'
docker rm -fv mongodb
docker network rm devops-net 
docker image rm mongo

echo 'Paso 2.- Limpieza en Directorios'
rm -rRf ./database-data
rm -rRf ./database-key