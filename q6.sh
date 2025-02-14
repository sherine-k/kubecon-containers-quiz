#!/bin/bash

########################
# include the magic
########################
. bin/demo-magic.sh

# hide the evidence
clear
if [[ "$OSTYPE" != "darwin"* ]]; then
  shopt -s expand_aliases
  source ~/.bashrc
fi

# Pre-requisites: docker, podman, gophers-api GH repo

# QUESTION 6

#p "Q6. L’image que je build fonctionne partout ?"
p "Creating a builder for building multi-arch container images, and using it"
p 'docker buildx create --name mybuilder --bootstrap --use'

p 'Inspecting the builder'
pe 'docker buildx inspect mybuilder'

cd gophers-api
p "Building an image for amd64 & arm64 and pushing it directly to the registry"
pe 'docker buildx build --push --platform linux/arm64/v8,linux/amd64  --builder mybuilder -t scraly/gophers-api:multi-arch .'

#It's not possible to push a multi-platform image to a docker engine.
#Instead all images in the engine are single platform, and you push the multi-platform image directly to the selected registry.
#You can pull the image to get the version for your platform:

cd
p "Pulling the multi-arch image locally"
pe 'docker pull scraly/gophers-api:multi-arch'

# Check the image have been correctly pulled
pe 'docker image ls scraly/gophers-api:multi-arch'

p 'Displaying the manifest'
pe 'docker manifest inspect scraly/gophers-api:multi-arch'

p 'Checking on the registry: https://hub.docker.com/r/scraly/gophers-api/tags'

p "Done !"
