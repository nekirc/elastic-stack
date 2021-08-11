#!/bin/bash
# Create certs to enable TLS communication
docker-compose -f create-certs.yml run --rm create_certs

# Build all containters from official images
docker-compose -f elastic-docker-tls.yml up -d

# Set build-in passwords
docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url https://es01:9200"

# Restart all containters
docker-compose stop
docker-compose -f elastic-docker-tls.yml up -d


## WORKSTATION DEPLOY

docker build --rm -t local/c7-systemd .
docker run --privileged --name=test1 --network=es_elastic -d local/c7-systemd

## PORTAINER DEPLOY

docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
