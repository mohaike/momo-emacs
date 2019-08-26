#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
cd "${CURRENT_PATH}"/../..
git add .; git ci -m "auto commit"
git push
