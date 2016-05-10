#!/bin/bash

DOCKER_IMAGE=simonlee
PORT=4000

DOCKER_RUN="docker run --volume=$(pwd)/jekyll:/src/ -p ${PORT}:4000 ${DOCKER_IMAGE}"
JEKYLL_RUN="jekyll serve --watch --port 4000 --host 0.0.0.0 -- baseurl '' --draft"

COPY=(assets img _posts)
COPY_LENGTH=${#COPY[@]}

function help {
    echo "Options"
    echo "build - Build docker image"
    echo "serve - Run jekyll in docker"
    echo "proof - Run proofer"
}

function copy {
    for(( i=0; i<${COPY_LENGTH}; i = i + 1));
    do
    cp -r -u ${COPY[$i]} ./jekyll
    done

    (cd jekyll && ./scripts/generate-categories)
    (cd jekyll && ./scripts/generate-tags)

}


function build {
    docker build -t ${DOCKER_IMAGE} .
}

function serve {
    copy
    ${DOCKER_RUN} ${JEKYLL_RUN}
}

function check {
    ${DOCKER_RUN} htmlproofer ./_site --only-4xx --disable-external --empty-alt-ignore
}

if [ "$#" -eq 0 ] ; then
    help
elif [ "$1" = "build" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] ; then
    build
elif [ "$1" = "serve" ] ; then
    serve ${@:2}
elif [ "$1" = "copy" ] ; then
    copy
elif [ "$1" = "check" ] ; then
    check
fi
