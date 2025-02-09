#!/bin/bash

########################
# include the magic
########################
. bin/demo-magic.sh

# hide the evidence
clear

# Pre-requisites: docker, sed

# QUESTION 10

cd gophers-api

p "Building an image"
pe 'docker build . -t gophers-api:friday -f Dockerfile-golang21'

pe 'docker image ls gophers-api'

p "Switching from golang 1.21 to 1.20"
pe 'vi Dockerfile-golang21'

pe 'docker build . -t gophers-api:friday -f Dockerfile-golang21'

pe 'docker image ls gophers-api'

pe 'docker images -f dangling=true'

p "Deleting dangling images, freeing disk space"
pe "docker rmi \$(docker images -f dangling=true -q)"

p "/!\ Docker only - dangling images are only visible when containerd is used as the image store"

#Revert Dockerfile-golang21 golang version
if [[ "$OSTYPE" != "darwin"* ]]; then
    sed -i 's/1.20/1.21/g' Dockerfile-golang21
else
    sed -i '' 's/1.20/1.21/g' Dockerfile-golang21
fi

cd ..
p "Done !"
