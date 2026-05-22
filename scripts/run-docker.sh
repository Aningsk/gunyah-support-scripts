#!/bin/bash

# © 2022 Qualcomm Innovation Center, Inc. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause

set -e

VERSION_SCRIPT=$(dirname "${BASH_SOURCE[0]}")/version.sh
. ${VERSION_SCRIPT}

if [[ -z "${HOST_SHARED_DIR}" ]]; then
	HOST_SHARED_DIR="/home/$USER/share"
fi

echo "Host shared folder : ${HOST_TO_DOCKER_SHARED_DIR}"

if [[ -z "${HOST_TO_DOCKER_SHARED_DIR}" ]]; then
	HOST_TO_DOCKER_SHARED_DIR=`pwd`
fi

# add as many port mappings required as a single entry or a range
if [[ -z "$NO_PORT_MAP" ]]; then
	#PORT_MAPPINGS=" -p 1234-1235:1234-1235 "
	PORT_MAPPINGS=" -p 1234:1234 "
	PORT_MAPPINGS+=" -p 1235:1235 "
fi

DOCKER_MACHINE_NAME="hyp-dev-env"
CONTAINER_NAME="hyp-dev-container"

if [[ -z "$DOCKER_TAG" ]]; then
    DOCKER_TAG=" hyp-dev-term:${CURRENT_VER} "
fi

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} already exists. Skipping creation."
    exit 0
fi

# Create and run container in background
docker run --privileged -h ${DOCKER_MACHINE_NAME} -d \
	${PORT_MAPPINGS} \
	${ADDITIONAL_DOCKER_ARGS} \
	-v tools-vol:/usr/local/mnt \
	-v wsp-vol:/home/$USER/mnt \
	-v ${HOST_TO_DOCKER_SHARED_DIR}:${HOST_SHARED_DIR} \
	--name ${CONTAINER_NAME} \
	${DOCKER_TAG} \
	tail -f /dev/null

echo "Container ${CONTAINER_NAME} created and running in background."

# Print the method to recreate container:
echo -e "\nIf you need to recreate the container, please use:\n"
echo -e "\tdocker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}\n"
echo -e "\t./run-docker.sh\n"

