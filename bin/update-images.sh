#!/usr/bin/env bash

function updateImage() {
    # $1 should be in `ezs-python-server`, or `ezs-python-saxon-server` format
    # But `bases/ezs-python-server` is accepted too.
    CHANGING_BASE=${1/bases\//}
    CHANGING_BASE=${CHANGING_BASE%/}

    printf "Update images depending from %s\n\n" "$CHANGING_BASE"

    BASE_IMAGE_VERSION=$(node -e "console.log(require('./bases/$CHANGING_BASE/package.json').version)")
    BASE_IMAGE_TAG_BEGINNING=$(node -e "console.log(require('./bases/$CHANGING_BASE/package.json').scripts.build.split(':')[1].split('{')[0].slice(0,-2))")
    BASE_IMAGE_TAG="$BASE_IMAGE_TAG_BEGINNING-$BASE_IMAGE_VERSION"
    printf "Tag of the image: %s\n\n" "$BASE_IMAGE_TAG"

    DOCKERFILES=$(ls bases/*/Dockerfile template/Dockerfile services/*/Dockerfile)


    printf "Directly depending images:\n"

    DEPENDING_DOCKERFILES=$(grep -i "^FROM cnrsinist/$CHANGING_BASE:$BASE_IMAGE_TAG" $DOCKERFILES | sed -e 's/:.*$//')

    for DOCKERFILE in $DEPENDING_DOCKERFILES
    do
        printf " - %s\n" "$DOCKERFILE"
    done

}

updateImage "$1"
