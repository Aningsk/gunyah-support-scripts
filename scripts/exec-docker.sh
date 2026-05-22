#!/bin/bash

# © 2022 Qualcomm Innovation Center, Inc. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause

set -e

CONTAINER_NAME="hyp-dev-container"

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Error: Container ${CONTAINER_NAME} does not exist."
    echo "Please run ./run-docker.sh first to create the container."
    exit 1
fi

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Starting container ${CONTAINER_NAME}..."
    docker start ${CONTAINER_NAME}
fi

# Execute command or enter interactive shell
if [ $# -eq 0 ]; then
    # No arguments: enter bash shell
    docker exec -it ${CONTAINER_NAME} bash
else
    # Execute provided command
    docker exec -it ${CONTAINER_NAME} "$@"
fi

