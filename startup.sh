#!/bin/bash

PUBLIC_IP=localhost

# Start Docker Stack
docker network create skynet
docker-compose up -d

echo ""
echo "traefik  : http://traefik.${PUBLIC_IP}"
echo "Portainer: http://portainer.${PUBLIC_IP}"
echo "Jenkins  : http://jenkins.${PUBLIC_IP}"
echo "Gitlab   : http://gitlab.${PUBLIC_IP}"
echo ""
