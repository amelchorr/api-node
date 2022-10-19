#!/bin/bash

echo '==========================='
echo '=== ARCHIVO DE LIMPIEZA ==='
echo '==========================='
docker rm -fv mongodb
docker network rm devops-net 
docker image rm mongo