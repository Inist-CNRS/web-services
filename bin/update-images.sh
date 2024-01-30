#!/usr/bin/env bash

function dryRun() {
    printf "%s\n" "$*"
}

# This function updates the Docker images for a specified base.
# It parses the base name, extracts the version from its package.json, and
# constructs the beginning of the image tag.
#
# @param {string} base image name in the format `ezs-python-server` or
#                 `basees/ezs-python-saxon-server`
function updateBase() {
    # $1 should be in `ezs-python-server`, or `ezs-python-saxon-server` format
    # But `bases/ezs-python-server` is accepted too.
    CHANGING_BASE=${1/bases\//}
    CHANGING_BASE=${CHANGING_BASE%/}

    printf "Update images depending from %s (level %s)\n\n" "$CHANGING_BASE" "$LEVEL"

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

    printf "\nUpdating images:\n\n"

    for DOCKERFILE in $DEPENDING_DOCKERFILES
    do
        printf " - %s\n" "$DOCKERFILE"
        dryRun sed -i -e "s/cnrsinist\/$CHANGING_BASE:.*$/cnrsinist\/$CHANGING_BASE:$BASE_IMAGE_TAG/g" "$DOCKERFILE"
        IMAGE_DIR=$(dirname "$DOCKERFILE")
        TYPE=$(dirname "$IMAGE_DIR")
        if [ "$IMAGE_DIR" = "template" ]; then
            dryRun git add template
            dryRun git commit -m "Update template"
            dryRun git push
        else
            dryRun npm -w "$IMAGE_DIR" version patch
        fi
        if [ "$TYPE" = "bases" ]; then
            dryRun npm -w "$IMAGE_DIR" run build
            dryRun npm -w "$IMAGE_DIR" run publish
            printf "\n***** Don't forget to run \"%s\" *******\n" "updateBase $IMAGE_DIR"
        fi
        printf "\n"
    done
}

updateBase "$1"
