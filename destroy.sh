#!/bin/bash

echo '==========================='
echo '=== ARCHIVO DE LIMPIEZA ==='
echo '==========================='
docker rm -fv 
docker volume rm 
docker image rm 