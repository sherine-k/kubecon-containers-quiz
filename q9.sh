#!/bin/bash

########################
# include the magic
########################
. bin/demo-magic.sh

# hide the evidence
clear

cd q9

# Pre-requisites: docker scout, trivy, bom

# install trivy
# curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.58.1

# install docker scout (no need if you have docker desktop)
#  curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
#  sudo sh install-scout.sh

# install bom
# go install sigs.k8s.io/bom/cmd/bom@latest
podman login -u sunnytech -p SunnyTech2024 79352h8v.c1.de1.container-registry.ovh.net
oras login -u sunnytech -p SunnyTech2024 79352h8v.c1.de1.container-registry.ovh.net
p 'Generate an SBOM with Trivy'
# pe 'skopeo copy docker://registry.redhat.io/ubi9/ubi-micro:latest docker://79352h8v.c1.de1.container-registry.ovh.net/public/ubi9/ubi-micro:latest --remove-signatures'
pe 'trivy image --format spdx-json --output /tmp/result.json 79352h8v.c1.de1.container-registry.ovh.net/public/gophers-api:latest'

p 'Display the spdx, with bom'
pe 'bom document outline /tmp/result.json'

p 'Tips: bom, docker  scout and podman can also be used to generate an SBOM'
p 'docker scout sbom myimage:mytag --output sbom.txt'
p 'podman build . -t myimage:mytag --sbom-scanner-command trivy --sbom-output sbom.txt'
p 'bom generate --image myimage:mytag --output=sbom.json --format json'
p "/!\ Same image && Different tool = different SBOM!!!"

# pe 'bom document outline scout_sbom.json'
# pe 'bom document outline bom_sbom.json'

p 'Reminder: some registries already accept to refer the SBOM to the image'
p 'oras attach 79352h8v.c1.de1.container-registry.ovh.net/public/gophers-api:latest --artifact-type application/spdx+json trivy_sbom.json:text/spdx+json'

# p '# Regardons la registry... https://79352h8v.c1.de1.container-registry.ovh.net/harbor/projects/2/repositories/ubi9%2Fubi-micro/artifacts-tab'

# pe 'oras discover 79352h8v.c1.de1.container-registry.ovh.net/public/ubi9/ubi-micro:latest'

# p 'oras discover sherinefedora:5000/ubi9/ubi-micro:latest'
# cat oras_discover_distrib.out

cd ..
p "Done !"

#https://github.com/goharbor/harbor/issues/21276