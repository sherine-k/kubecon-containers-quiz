#!/bin/bash

########################
# include the magic
########################
. bin/demo-magic.sh

# hide the evidence
clear

# Pre-requisites: docker, podman, gophers-api GH repo

# QUESTION 4

#p "Q4. What happens when I push an image to a registry?"
cd gophers-api

# Login to the MPR
p 'docker login -u kubecon 79352h8v.c1.de1.container-registry.ovh.net'
docker login -u sunnytech -p SunnyTech2024 79352h8v.c1.de1.container-registry.ovh.net

# Build the image
pe 'docker build -t 79352h8v.c1.de1.container-registry.ovh.net/public/gophers-api:latest .'

# Check the image size locally
pe 'docker image ls 79352h8v.c1.de1.container-registry.ovh.net/public/gophers-api:latest'

# Push the image in an OVHcloud Private Registry
pe 'docker push 79352h8v.c1.de1.container-registry.ovh.net/public/gophers-api:latest'

# Check the image size on MPR and DockerHub
p 'Checking on OVHcloud private registry: 79352h8v.c1.de1.container-registry.ovh.net'
# 22.6MB en local → 10.82MiB sur OVHcloud Managed Private Registry / Harbor ;-)
p 'Checking on Docker Hub: https://hub.docker.com/r/scraly/gophers-api/tags'

# zstd recommended for large images, IA!
p 'Tips with Podman: changing compression mode during the push'
p 'podman push docker.io/scraly/gophers-api:podman-zstd --compression-format=zstd'

p "Tips: changing compression mode with Docker too"
p "docker buildx build --output type=image,name=scraly/gophers-api:docker-zstd,oci-mediatypes=true,compression=zstd,compression-level=3,force-compression=true,push=true --push ."
# p "docker manifest inspect -v scraly/gophers-api:docker-zstd | grep 'application/vnd.oci.image.layer.v1.tar+zstd'"
# cat ../q4/gophers-api-docker-zstd-manifest.json | grep 'application/vnd.oci.image.layer.v1.tar+zstd'

cd
p "Done!"
