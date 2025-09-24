#!/usr/bin/env bash

cd /tmp
tar czf "${1}.tar.gz" "${1}.gexf" "${1}.png"
echo "\"${1}.tar.gz\""
