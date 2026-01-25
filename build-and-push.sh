#!/bin/bash
set -euo pipefail

# Script to build and push a multi-architecture Docker image using buildx
# Usage: ./build-and-push.sh <registry-path>
# Example: ./build-and-push.sh docker.io/username/repo

if [ $# -ne 1 ]; then
    echo "Error: Registry path required"
    echo "Usage: $0 <registry-path>"
    echo "Example: $0 docker.io/username/repo"
    exit 1
fi

REGISTRY_PATH="$1"

if [[ "$REGISTRY_PATH" =~ ^([^/]+) ]]; then 
    REGISTRY_HOST="${BASH_REMATCH[1]}"
else
    echo "Error: Invalid registry path format: $REGISTRY_PATH"
    exit 1
fi

DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker/config.json}"
if [ ! -f "$DOCKER_CONFIG" ]; then
    echo "Error: Docker config not found. Not logged in to registry: $REGISTRY_HOST"
    echo "Please run: docker login $REGISTRY_HOST"
    exit 1
fi

if ! grep -q "$REGISTRY_HOST" "$DOCKER_CONFIG" 2>/dev/null; then
    echo "Warning: Registry '$REGISTRY_HOST' not found in docker config"
    echo "Attempting build anyway - authentication will be validated during push"
fi

if ! command -v git &> /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

if ! git rev-parse --git-dir &> /dev/null; then
    echo "Error: Not in a git repository"
    exit 1
fi

COMMIT_SHA=$(git rev-parse --short HEAD)
if [ -z "$COMMIT_SHA" ]; then
    echo "Error: Could not determine commit SHA"
    exit 1
fi

if ! docker buildx version &> /dev/null; then
    echo "Error: docker buildx is not available"
    exit 1
fi

BUILDER_NAME="multiarch-builder"
if ! docker buildx inspect "$BUILDER_NAME" &> /dev/null; then
    echo "Creating buildx builder: $BUILDER_NAME"
    docker buildx create --name "$BUILDER_NAME" --use --bootstrap
else
    echo "Using existing buildx builder: $BUILDER_NAME"
    docker buildx use "$BUILDER_NAME"
fi

echo "Building multi-architecture image..."
echo "Registry: $REGISTRY_PATH"
echo "Tags: latest, sha-$COMMIT_SHA"
echo "Architectures: linux/amd64, linux/arm64"

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --tag "${REGISTRY_PATH}:latest" \
    --tag "${REGISTRY_PATH}:sha-${COMMIT_SHA}" \
    --push \
    --file Dockerfile \
    .

echo ""
echo "Successfully built and pushed:"
echo "  - ${REGISTRY_PATH}:latest"
echo "  - ${REGISTRY_PATH}:sha-${COMMIT_SHA}"
