#!/bin/bash -xe

if [[ -e .git && ! -z "$(git status --untracked-files=no --porcelain)" ]]; then
    >&2 echo "Uncommited changes, commit your changes first"
    exit 1
fi
