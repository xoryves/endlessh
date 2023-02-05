#!/bin/sh
# build create cp binary

cd "$(dirname "$(dirname "$(readlink "$0")")")"

docker build . --rm -t endlessh:latest
docker create --name endlessh endlessh:latest
docker cp endlessh:/endlessh .
docker rm endlessh
docker image prune --filter label=stage=builder
