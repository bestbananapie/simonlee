#!/bin/bash

DOCKER_IMAGE=simonlee
PORT=8000

DOCKER_RUN="docker run --volume=$(pwd)/jekyll:/src/ -p ${PORT}:4000 ${DOCKER_IMAGE}"

function help {
    echo "Options"
    echo "build - Build docker image"
    echo "serve - Run jekyll in docker"
    echo "proof - Run proofer"
}

function build {
    docker build -t ${DOCKER_IMAGE} .
}

function serve {
    ${DOCKER_RUN}
}

function check {
    ${DOCKER_RUN} htmlproofer ./_site --only-4xx --disable-external
}

if [ "$#" -eq 0 ] ; then
    help
elif [ "$1" = "build" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] ; then
    build
elif [ "$1" = "serve" ] ; then
    serve
elif [ "$1" = "check" ] ; then
    check
fi
