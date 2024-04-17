#!/usr/bin/env bash

source bin/markdown.sh

for file in "$@"; do
    insert_description post.description "$file"
done
