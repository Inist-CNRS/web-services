#!/usr/bin/env bash

cd /tmp/retrieve/
tar czf "${1}.tar.gz" "${1}/"
echo "\"${1}.tar.gz\""
